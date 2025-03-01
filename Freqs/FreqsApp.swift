////
////  FreqsApp.swift
////  Freqs
////
////  Created by Nicholas Conant-Hiley on 2/28/25.
////
//
//import SwiftUI
//import SwiftData
//
//@main
//struct FreqsApp: App {
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
////        .modelContainer(for: [HapticSession.self])
//    }
//}
import SwiftUI
import SwiftData

@main
struct FreqsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [HapticSession.self])
    }
}
