//////
//////  WatchSync.swift
//////  Freqs
//////
//////  Created by Nicholas Conant-Hiley on 3/1/25.
//////
////
////import WatchConnectivity
////import SwiftData
////import Foundation
////
////class WatchDataReceiver: NSObject, WCSessionDelegate, ObservableObject {
////    @Published var latestSession: HapticSession?
////    private let modelContext: ModelContext
////
////    init(modelContext: ModelContext) {
////        self.modelContext = modelContext
////        super.init()
////        if WCSession.isSupported() {
////            WCSession.default.delegate = self
////            WCSession.default.activate()
////        }
////    }
////    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
////        DispatchQueue.main.async { [self] in  // ✅ Ensure async block is properly formatted
////            guard let startTimeInterval = message["startTime"] as? TimeInterval,
////                  let endTimeInterval = message["endTime"] as? TimeInterval,
////                  let initialBPM = message["initialBPM"] as? Double,
////                  let finalBPM = message["finalBPM"] as? Double,
////                  let bpmRecords = message["bpmRecords"] as? [Double] else {
////                print("❌ Failed to decode received message.")
////                return
////            }
////
////            let session = HapticSession(
////                startTime: Date(timeIntervalSince1970: startTimeInterval),
////                endTime: Date(timeIntervalSince1970: endTimeInterval),
////                initialBPM: initialBPM,
////                finalBPM: finalBPM,
////                bpmRecords: bpmRecords
////            )
////
////            print("📅 Session Start Time: \(session.startTime)")
////
////    //        let dataManager = HapticDataManager(modelContext: self.modelContext)
////    //        dataManager.saveSession(session: session)
////    //        self.latestSession = session
////    //        print("✅ Haptic Session Saved: \(session)")
////        }
////    }
//////    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
//////        DispatchQueue.main.async {
//////            guard let startTimeInterval = message["startTime"] as? TimeInterval,
//////                  let endTimeInterval = message["endTime"] as? TimeInterval,
//////                  let initialBPM = message["initialBPM"] as? Double,
//////                  let finalBPM = message["finalBPM"] as? Double,
//////                  let bpmRecords = message["bpmRecords"] as? [Double] else { return }
//////
//////            let session = HapticSession(
//////                startTime: Date(timeIntervalSince1970: startTimeInterval),
//////                endTime: Date(timeIntervalSince1970: endTimeInterval),
//////                initialBPM: initialBPM,
//////                finalBPM: finalBPM,
//////                bpmRecords: bpmRecords
//////            )
//////            print(session.startTime)
//////
////////            let dataManager = HapticDataManager(modelContext: self.modelContext)
////////            dataManager.saveSession(session: session)
////////            self.latestSession = session
////////            print("✅ Haptic Session Saved: \(session)")
//////        }
//////    }
//////
//////    func sessionDidBecomeInactive(_ session: WCSession) {}
//////    func sessionDidDeactivate(_ session: WCSession) {}
//////    func session(_ session: WCSession, activationDidCompleteWith state: WCSessionActivationState, error: Error?) {}
//////}
////
////  WatchSync.swift
////  Freqs
////
////  Created by Nicholas Conant-Hiley on 3/1/25.
////
//
//import WatchConnectivity
//import SwiftData
//import Foundation
//
//class WatchDataReceiver: NSObject, WCSessionDelegate, ObservableObject {
//    @Published var latestSession: HapticSession?
//    private let modelContext: ModelContext
//
//    init(modelContext: ModelContext) {
//        self.modelContext = modelContext
//        super.init()
//        if WCSession.isSupported() {
//            WCSession.default.delegate = self
//            WCSession.default.activate()
//        }
//    }
//
//    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
//        DispatchQueue.main.async {
//            guard let startTimeInterval = message["startTime"] as? TimeInterval,
//                  let endTimeInterval = message["endTime"] as? TimeInterval,
//                  let initialBPM = message["initialBPM"] as? Double,
//                  let finalBPM = message["finalBPM"] as? Double,
//                  let bpmRecords = message["bpmRecords"] as? [Double] else {
//                print("❌ Failed to decode received message.")
//                return
//            }
//
//            let receivedSession = HapticSession(
//                startTime: Date(timeIntervalSince1970: startTimeInterval),
//                endTime: Date(timeIntervalSince1970: endTimeInterval),
//                initialBPM: initialBPM,
//                finalBPM: finalBPM,
//                bpmRecords: bpmRecords
//            )
//
//            print("📅 Session Start Time: \(receivedSession.startTime)")
//
//            // ✅ Ensure the session is saved to SwiftData
//            self.saveSessionToSwiftData(session: receivedSession)
//        }
//    }
//
//    /// Saves the received session into SwiftData
//    private func saveSessionToSwiftData(session: HapticSession) {
//        modelContext.insert(session)
//        do {
//            try modelContext.save()
//            self.latestSession = session
//            print("✅ Haptic Session Successfully Saved to SwiftData: \(session)")
//        } catch {
//            print("❌ Error saving session to SwiftData: \(error.localizedDescription)")
//        }
//    }
//
//    func sessionDidBecomeInactive(_ session: WCSession) {}
//    func sessionDidDeactivate(_ session: WCSession) {}
//    func session(_ session: WCSession, activationDidCompleteWith state: WCSessionActivationState, error: Error?) {}
//}
