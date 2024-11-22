//
//  SessionDataService.swift
//  PingStats
//
//  Created by Elvis Dorow on 18/11/24.
//

import Foundation
import CoreData

class SessionDataService: DataService {
    private let entityName = "Sessions"
    
    static let instance = SessionDataService()
    
    private override init() {
        super.init()
    }
    
    func load() -> [Sessions] {
        let request = NSFetchRequest<Sessions>(entityName: entityName)
        request.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: false)]
        
        do {
            return try container.viewContext.fetch(request)
        } catch let error {
            print("Error loading sessions \(error)")
        }
        return []
    }
    
    func add(session: Session) {
        
        let newSession: Sessions = Sessions(context: container.viewContext)
        
        guard let pingStat = session.pingStat else { return }
        
        newSession.startDate = session.startDate
        newSession.endDate = session.endDate
        newSession.host = session.parameters.host
        newSession.hostname = session.parameters.hostname
        
        newSession.connectionType = session.connectionType
        
        newSession.bestPing = pingStat.bestPing
        newSession.worstPing = pingStat.worstPing
        newSession.jitter = pingStat.jitter
        newSession.averagePing = pingStat.averagePing
        newSession.packageLoss = pingStat.packageLoss
        
        newSession.generalScore = pingStat.generalScore
        newSession.streamingScore = pingStat.streamingScore
        newSession.videoCallScore = pingStat.videoCallScore
        newSession.gamingScore = pingStat.gamingScore
        
        newSession.pingCount = Int16(session.responses.count)
        
        newSession.elapsedTime = session.elapsedTime
        
        newSession.pingTimeout = Int16(session.parameters.pingTimeout.rawValue)
        newSession.pingInterval = Int16(session.parameters.pingInterval.rawValue)
        newSession.maxtimeSetting = Int16(session.parameters.maxtimeSetting.rawValue)

        var logs: [SessionLog] = []
        for pingLog in session.pingLogs {
            let sessionLog = SessionLog(context: container.viewContext)
            sessionLog.sequence = Int32(pingLog.sequence)
            sessionLog.bytes = Int32(pingLog.bytes)
            sessionLog.duration = pingLog.duration
            sessionLog.timeToLive = Int32(pingLog.timeToLive)
            sessionLog.dateTime = pingLog.dateTime
            sessionLog.error = pingLog.error

            logs.append(sessionLog)
        }
        newSession.logs = NSOrderedSet(array: logs)

        save()
    }
}
