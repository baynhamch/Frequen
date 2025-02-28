//
//  ContentView.swift
//  Freqs Watch App
//
//  Created by Nicholas Conant-Hiley on 2/28/25.
//

import SwiftUI

struct ContentView: View {
    let hapticManager = HapticFrequencyManager()
    
    var body: some View {
        VStack {
            Text("ADHD / Anxiety Vibration")
                .font(.headline)
                .padding()
            
            Button("Calm Mode (3 Hz)") {
                hapticManager.startHaptic(frequency: 3, duration: 60) // Vibrates at 3 Hz for 1 minute
            }
            .padding()
            
            Button("Focus Mode (10 Hz)") {
                hapticManager.startHaptic(frequency: 10, duration: 60) // Vibrates at 10 Hz for 1 minute
            }
            .padding()

            Button("Stop Vibration") {
                hapticManager.stopHaptic()
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
