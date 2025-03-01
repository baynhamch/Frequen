//
//import HealthKit
//import WatchKit
//
//class HealthKitManager: ObservableObject {
//    private var healthStore = HKHealthStore()
//    
//    @Published var heartRate: Double = 0.0
//    @Published var currentWatchbeat: Double = 0.0  // Syncs HR with haptics
//    @Published var heartRateVariability: Double = 0.0
//    
//    private var heartRateAnchor: HKQueryAnchor?
//    private var hapticManager = HapticFrequencyManager() // Haptics manager
//
//    // MARK: - Request HealthKit Authorization
//    func requestAuthorization() {
//        let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
//        let hrvType = HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!
//        
//        let typesToRead: Set = [heartRateType, hrvType]
//        
//        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { success, error in
//            if success {
//                print("✅ HealthKit Authorization Successful!")
//            } else {
//                print("❌ HealthKit Authorization Failed: \(error?.localizedDescription ?? "Unknown Error")")
//            }
//        }
//    }
//    
//    // MARK: - Start Live Heart Rate Monitoring
//    func startHeartRateMonitoring() {
//        let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
//        
//        let query = HKAnchoredObjectQuery(
//            type: heartRateType,
//            predicate: nil,
//            anchor: heartRateAnchor,
//            limit: HKObjectQueryNoLimit
//        ) { query, samples, _, newAnchor, error in
//            self.processHeartRateSamples(samples, newAnchor: newAnchor, error: error)
//        }
//        
//        query.updateHandler = { query, samples, _, newAnchor, error in
//            self.processHeartRateSamples(samples, newAnchor: newAnchor, error: error)
//        }
//        
//        healthStore.execute(query)
//    }
//    
//    // MARK: - Process Heart Rate Samples
//    private func processHeartRateSamples(_ samples: [HKSample]?, newAnchor: HKQueryAnchor?, error: Error?) {
//        guard let samples = samples as? [HKQuantitySample], error == nil else {
//            print("Error fetching heart rate: \(error?.localizedDescription ?? "Unknown error")")
//            return
//        }
//        
//        DispatchQueue.main.async {
//            self.heartRate = samples.last?.quantity.doubleValue(for: HKUnit(from: "count/min")) ?? 0.0
//            self.currentWatchbeat = self.heartRate // Sync HR to haptic feedback
//            self.heartRateAnchor = newAnchor
//            
//            // Start or update haptic feedback
//            self.hapticManager.updateHaptic(bpm: self.heartRate)
//
//            print("💓 Live Heart Rate: \(self.heartRate) BPM")
//        }
//    }
//    
//    // MARK: - Fetch Latest HRV
//    func fetchHRV() {
//        let hrvType = HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!
//        let query = HKSampleQuery(
//            sampleType: hrvType,
//            predicate: nil,
//            limit: 1,
//            sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)]
//        ) { _, samples, error in
//            guard let sample = samples?.first as? HKQuantitySample, error == nil else {
//                print("Error fetching HRV: \(error?.localizedDescription ?? "Unknown error")")
//                return
//            }
//            DispatchQueue.main.async {
//                self.heartRateVariability = sample.quantity.doubleValue(for: HKUnit.secondUnit(with: .milli))
//                print("⚡ HRV Updated: \(self.heartRateVariability) ms")
//            }
//        }
//        healthStore.execute(query)
//    }
//    
//    // MARK: - Stop Monitoring & Haptics
//    func stopMonitoring() {
//        hapticManager.stopHaptic() // Stop haptic feedback
//        print("🛑 Stopped Heart Rate Monitoring & Haptics")
//    }
//}
import HealthKit

class HealthKitManager: ObservableObject {
    private var healthStore = HKHealthStore()
    private var hapticManager = HapticFrequencyManager()

    @Published var heartRate: Double = 0.0
    @Published var heartRateVariability: Double = 0.0
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
                print("❌ Authorization Failed: \(error?.localizedDescription ?? "Unknown error")")
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
            guard let samples = samples as? [HKQuantitySample], error == nil else {
                print("❌ Error fetching HR: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            DispatchQueue.main.async {
                self.heartRate = samples.last?.quantity.doubleValue(for: HKUnit(from: "count/min")) ?? 0.0
                self.heartRateAnchor = newAnchor
                print("💓 Live Heart Rate: \(self.heartRate) BPM")
                print(self.hapticManager.currentBPM)
                
                // ✅ Start haptic with slow decrease
                self.hapticManager.startHaptic(bpm: self.heartRate)
            }
        }

        query.updateHandler = { query, samples, _, newAnchor, error in
            guard let samples = samples as? [HKQuantitySample], error == nil else {
                print("❌ Error updating HR: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            DispatchQueue.main.async {
                self.heartRate = samples.last?.quantity.doubleValue(for: HKUnit(from: "count/min")) ?? 0.0
                self.heartRateAnchor = newAnchor
                print("💓 Updated Heart Rate: \(self.heartRate) BPM")
                print("Current Haptic BPM: \(self.hapticManager.currentBPM)")
            }
        }
        
        healthStore.execute(query)
    }
    
    func stopMonitoring() {
        hapticManager.stopHaptic()
        print("🛑 Stopped Monitoring & Haptics")
    }
}
