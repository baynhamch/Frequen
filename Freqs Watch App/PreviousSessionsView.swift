//
//  PreviousSessionsView.swift
//  Freqs Watch App
//
//  Created by Nicholas Conant-Hiley on 3/1/25.
//

import SwiftUI

struct PreviousSessionsView: View {
    @StateObject private var healthKitManager = HealthKitManager()
    var body: some View {
        ScrollView {
            VStack {
                Text("Previous Sessions")
                ForEach(healthKitManager.completedSessions, id: \.id) { session in
                    Text("BPM: \(session.heartbeat), Time: \(session.timeDuration) sec")
//                    Text(session.watchbeat)
                }
            }
        }
    }
}

#Preview {
    PreviousSessionsView()
}
