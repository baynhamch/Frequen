
import SwiftUI

struct ContentView: View {
    @StateObject private var healthKitManager = HealthKitManager()
    
    var body: some View {
        VStack {
            Text("💓 Heart Rate: \(Int(healthKitManager.heartRate)) BPM")
//            Text("🎵 Watch Beat: \(Int(healthKitManager.currentWatchbeat)) BPM")
//                .onChange(of: healthKitManager.currentWatchbeat) { newValue in
//                    print("🔽 Decreasing Haptic BPM: \(newValue)")
//                }
            
            Button("Start Monitoring") {
                healthKitManager.requestAuthorization()
                healthKitManager.startHeartRateMonitoring()
                print("🚀 Monitoring Started")
            }
            .padding()
            
            Button("Stop") {
                healthKitManager.stopMonitoring()
            }
            .padding()
            .foregroundColor(.red)
        }
    }
}

#Preview {
    ContentView()
}
