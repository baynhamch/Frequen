////
////  HapticsDataManger.swift
////  Freqs
////
////  Created by Nicholas Conant-Hiley on 3/1/25.
////
//
//import SwiftData
//import Foundation
//import SwiftData  // ✅ Import SwiftData
//import WatchKit
//
//class HapticDataManager {
//    private let modelContext: ModelContext
//
//    init(modelContext: ModelContext) {
//        self.modelContext = modelContext
//    }
//
//    func saveSession(session: HapticSession) {
//        modelContext.insert(session)
//        try? modelContext.save()
//    }
//
//    func fetchSessions() -> [HapticSession] {
//        let fetchDescriptor = FetchDescriptor<HapticSession>(sortBy: [SortDescriptor(\.startTime, order: .reverse)])
//        return (try? modelContext.fetch(fetchDescriptor)) ?? []
//    }
//}
