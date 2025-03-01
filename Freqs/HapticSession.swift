//import SwiftData
//import Foundation
//
//@Model
//class HapticSession: Identifiable {
//    @Attribute(.unique) var id: UUID = UUID()
//    var startTime: Date
//    var endTime: Date
//    var initialBPM: Double
//    var finalBPM: Double
//    var bpmRecords: [Double]
//
//    init(startTime: Date, endTime: Date, initialBPM: Double, finalBPM: Double, bpmRecords: [Double]) {
//        self.startTime = startTime
//        self.endTime = endTime
//        self.initialBPM = initialBPM
//        self.finalBPM = finalBPM
//        self.bpmRecords = bpmRecords
//    }
//}
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
import SwiftData
import Foundation

@Model
class HapticSession: Identifiable {
    @Attribute(.unique) var id: UUID = UUID()
    var startTime: Date
    var endTime: Date?
    var duration: TimeInterval? // Elapsed time in seconds
    var initialBPM: Double
    var finalBPM: Double?
    var bpmRecords: [Double] // Stores BPM history during session

    init(startTime: Date, initialBPM: Double) {
        self.startTime = startTime
        self.initialBPM = initialBPM
        self.bpmRecords = [initialBPM]
    }

    func endSession(finalBPM: Double) {
        self.endTime = Date()
        self.finalBPM = finalBPM
        self.duration = endTime?.timeIntervalSince(startTime) // Calculate elapsed time
    }

    func recordBPM(_ bpm: Double) {
        bpmRecords.append(bpm)
    }
}
