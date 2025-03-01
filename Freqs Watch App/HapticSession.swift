//
//  HapticSession.swift
//  Freqs Watch App
//
//  Created by Nicholas Conant-Hiley on 3/1/25.
//

import Foundation
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
