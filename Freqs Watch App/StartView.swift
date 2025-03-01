//
//  StartView.swift
//  Freqs Watch App
//
//  Created by Nicholas Conant-Hiley on 3/1/25.
//

import SwiftUI

struct StartView: View {
    var body: some View {
        NavigationLink(destination: SessionView()) {
            Text("Start Session")
        }
    }
}

#Preview {
    StartView()
}
