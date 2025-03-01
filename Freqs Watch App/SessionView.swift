//
//  SessionView.swift
//  Freqs Watch App
//
//  Created by Nicholas Conant-Hiley on 3/1/25.
//

import SwiftUI
import Charts

struct SessionView: View {
    @StateObject private var healthKitManager = HealthKitManager()

    var body: some View {
        TabView {
            VStack {
                CircleSpinnerView()
                    .padding(.bottom, 25)
                Spacer()
                VStack(alignment: .leading, spacing: 7) {
                    Text("Heart Rate: \(Int(healthKitManager.heartRate)) BPM")
                    Text("Watch Beat: \(Int(healthKitManager.currentWatchBeat)) BPM")
                }.font(.system(size: 10))
            }
            VStack {
                Text("Time Remaining")
                Text("\(healthKitManager.timeRemaining) sec")  // ✅ Live countdown
                               .font(.largeTitle)
                               .bold()
                               .onChange(of: healthKitManager.timeRemaining) { newValue in
                                   print("🔄 Updated Time Remaining: \(newValue) sec")  // ✅ Debugging log
                               }
                Button {
                    healthKitManager.stopSession()
                } label: {
                    Text("Stop")
                }
            }
        }
        .onAppear {
            healthKitManager.startSession()
        }
            //                .onChange(of: healthKitManager.currentWatchbeat) { newValue in
            //                    print("🔽 Decreasing Haptic BPM: \(newValue)")
            //                }
        }
        //        Chart(heartRateData) { dataPoint in
        //                      LineMark(
        //                          x: .value("Time", dataPoint.time),
        //                          y: .value("BPM", dataPoint.bpm)
        //                      )
        //                      .foregroundStyle(.red)
        //                      .symbol(.circle)
        //    }
   
}
#Preview {
    SessionView()
}
