
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
