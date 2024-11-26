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
            for case let sessionLog as SessionLog in orderedSet {
                if let error = sessionLog.error {
                    logs.append(PingLog(sequence: Int(sessionLog.sequence), error: error))
                } else {
                    let pingLog = PingLog(
                        date: sessionLog.dateTime ?? .now,
                        sequence: Int(sessionLog.sequence),
                        bytes: Int(sessionLog.bytes),
                        timeToLive: Int(sessionLog.timeToLive),
                        duration: sessionLog.duration
                        
                    )
                    logs.append(pingLog)
                }
            }
        }
    }
}

