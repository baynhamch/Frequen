
import HealthKit

class Session {
    var id: UUID
    var heartbeat: Double
    var heartbeatTimeStart: Date
    var watchbeat: Double
    var timeDuration: Double
    
    init(id: UUID, heartbeat: Double, heartbeatTimeStart: Date, watchbeat: Double, timeDuration: Double) {
        self.id = id
        self.heartbeat = heartbeat
        self.heartbeatTimeStart = heartbeatTimeStart
        self.watchbeat = watchbeat
        self.timeDuration = timeDuration
    }
}

class HealthKitManager: ObservableObject {
    private var healthStore = HKHealthStore()
    private var hapticManager = HapticFrequencyManager()
    private var session: Session?
    private var sessionTimer: Timer?
    
    @Published var heartRate: Double = 0.0
    @Published var heartRateVariability: Double = 0.0
    @Published var currentWatchBeat: Double = 0.0
    @Published var startTime: Date?
    @Published var completedSessions: [Session] = []
    @Published var timeRemaining: Int = 60

    private var heartRateAnchor: HKQueryAnchor?

    // MARK: - Request HealthKit Authorization
    func requestAuthorization() {
        let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
        let hrvType = HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!
        
        let typesToRead: Set = [heartRateType, hrvType]
        
        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { success, error in
            if success {
                print("✅ HealthKit Authorized")
            } else {
                print("Error")
            }
        }
    }

    // MARK: - Start Live Heart Rate Monitoring
    func startHeartRateMonitoring() {
        let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
        
        let query = HKAnchoredObjectQuery(
            type: heartRateType,
            predicate: nil,
            anchor: heartRateAnchor,
            limit: HKObjectQueryNoLimit
        ) { query, samples, _, newAnchor, error in
            self.processHeartRateSamples(samples: samples, newAnchor: newAnchor, error: error)
        }

        query.updateHandler = { query, samples, _, newAnchor, error in
            self.processHeartRateSamples(samples: samples, newAnchor: newAnchor, error: error)
        }
        
        healthStore.execute(query)
    }
    
    // MARK: - Process Heart Rate Samples
    private func processHeartRateSamples(samples: [HKSample]?, newAnchor: HKQueryAnchor?, error: Error?) {
        guard let samples = samples as? [HKQuantitySample], let latestSample = samples.last, error == nil else {
            print("Error fetching heart rate samples")
            return
        }

        DispatchQueue.main.async {
            let newHeartRate = latestSample.quantity.doubleValue(for: HKUnit(from: "count/min"))
            self.heartRate = newHeartRate
            self.currentWatchBeat = self.hapticManager.currentBPM
            self.hapticManager.startHaptic(bpm: self.heartRate)
            
            let sessionEntry = Session(
                id: UUID(),
                heartbeat: newHeartRate,
                heartbeatTimeStart: Date(),
                watchbeat: self.currentWatchBeat,
                timeDuration: 0.0
            )
            
            self.completedSessions.append(sessionEntry)
            print("💓 Updated Heart Rate: \(self.heartRate) BPM - Session Recorded")
            
            self.heartRateAnchor = newAnchor
        }
    }
    // MARK: - Timer

    func startCountdown(seconds: Int, completion: @escaping (Bool) -> Void) {
        var timeRemaining = seconds

        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if timeRemaining > 0 {
                timeRemaining -= 1
                print("⏳ Time Remaining: \(timeRemaining) sec")
            } else {
                timer.invalidate()
                print("✅ Countdown Complete")
                completion(true)  // Return `true` when countdown finishes
            }
        }
    }

    // MARK: - Start Timed Session
    func startSession() {
        self.requestAuthorization()
        self.startHeartRateMonitoring()
        self.startTime = Date()
        
        print("🚀 Session Started at \(self.startTime!)")
        
        var timeRemaining = self.timeRemaining  // ✅ Start countdown from 60 seconds

        // ✅ Start a repeating timer to count down every second
        sessionTimer?.invalidate()
        sessionTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if timeRemaining > 0 {
                print("⏳ Time Remaining: \(timeRemaining) sec")
                timeRemaining -= 1
            } else {
                timer.invalidate()
                print("✅ Countdown Complete - Stopping Session")
                self.stopSession()
            }
        }
    }
//    func startSession() {
//        self.requestAuthorization()
//        self.startHeartRateMonitoring()
//        self.startTime = Date()
////        self.completedSessions = [] // Reset session log
//
//        print("🚀 Session Started at \(self.startTime!)")
//        
//        // Automatically stop the session after 60 seconds
//        sessionTimer?.invalidate()
//        sessionTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: false) { _ in
//            self.stopSession()
//        }
//        print(startTime)
//    }

    // MARK: - Stop Session
    func stopSession() {
        sessionTimer?.invalidate()
        hapticManager.stopHaptic()
        self.startHeartRateMonitoring()
        let endTime = Date()

        if let startTime = startTime {
            let duration = endTime.timeIntervalSince(startTime)
            for index in completedSessions.indices {
                completedSessions[index].timeDuration = duration
            }
            print("🛑 Session Ended. Duration: \(duration) seconds")
        }

        print("🛑 Stopped Monitoring & Haptics. Saved \(completedSessions.count) heart rate readings.")
    }
}
