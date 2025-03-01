
import WatchKit

class HapticFrequencyManager {
    var timer: Timer?
    var currentBPM: Double = 0.0
    var targetBPM: Double = 60.0 // Resting heart rate
    var decreaseRate: Double = 5.0 // Decrease by 5 BPM every 10 seconds
    var decreaseInterval: TimeInterval = 10.0 // Time between decreases

    func startHaptic(bpm: Double) {
        guard bpm > 0 else { return }
        currentBPM = bpm
        updateHaptic()
    }

    func updateHaptic() {
        guard currentBPM > targetBPM else {
            stopHaptic() // Stop once resting BPM is reached
            return
        }

        let interval = 60.0 / currentBPM // Convert BPM to seconds per beat

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            WKInterfaceDevice.current().play(.notification) // Stronger tap
        }

        // Schedule gradual decrease every 10 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + decreaseInterval) {
            self.currentBPM = max(self.targetBPM, self.currentBPM - self.decreaseRate)
//            print("🔽 Decreasing Haptic BPM: \(self.currentBPM)")
            self.updateHaptic()
        }
    }

    func stopHaptic() {
        timer?.invalidate()
        print("🛑 Haptics Stopped at \(currentBPM) BPM")
    }
}
