//
//  HapticsManager.swift
//  Freqs Watch App
//
//  Created by Nicholas Conant-Hiley on 2/28/25.
//


import WatchKit

class HapticFrequencyManager {
    var timer: Timer?
    
    func startHaptic(frequency: Double, duration: Double) {
        let interval = 1.0 / frequency // Convert Hz to time interval
        var elapsedTime: Double = 0.0
        
        timer?.invalidate() // Ensure we stop any existing vibration loop
        
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { timer in
            WKInterfaceDevice.current().play(.click) // Play a haptic tap
            elapsedTime += interval
            
            if elapsedTime >= duration {
                timer.invalidate() // Stop after set duration
            }
        }
    }

    func stopHaptic() {
        timer?.invalidate()
    }
}
