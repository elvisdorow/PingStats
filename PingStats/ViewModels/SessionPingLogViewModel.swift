//
//  SessionPingLogViewModel.swift
//  PingStats
//
//  Created by Elvis Dorow on 25/11/24.
//

import Foundation
import CoreData

class SessionPingLogViewModel: ObservableObject {
    
    var session: Sessions
    @Published var logs: [PingLog] = []
    
    init(session: Sessions) {
        self.session = session
        self.getLogs()
    }
    
    private func getLogs() {
        let sortDescriptor = NSSortDescriptor(key: "dateTime", ascending: true)
        if let orderedSet = session.logs?.sortedArray(using: [sortDescriptor]) {
            var seq = 0
            for case let sessionLog as SessionLog in orderedSet {
                let pingLog = PingLog(
                    date: sessionLog.dateTime ?? .now,
                    sequence: Int(sessionLog.sequence),
                    bytes: Int(sessionLog.bytes),
                    timeToLive: Int(sessionLog.timeToLive),
                    duration: sessionLog.duration
                )
                logs.append(pingLog)
                seq += 1
            }
        }
    }
}

