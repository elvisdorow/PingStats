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
    
    @Published var sessions: [Sessions] = []
    
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
        newSession.resolvedIpOrHost = session.resolvedIpOrHost
        
        newSession.connectionType = session.connectionType
        
        newSession.bestPing = pingStat.bestPing
        newSession.worstPing = pingStat.worstPing
        newSession.jitter = pingStat.jitter
        newSession.averagePing = pingStat.averagePing
        newSession.packageLoss = pingStat.packageLoss
        
        newSession.generalScore = (pingStat.generalScore > 0) ? pingStat.generalScore : 0.0
        newSession.streamingScore = (pingStat.streamingScore > 0) ? pingStat.streamingScore : 0.0
        newSession.videoCallScore = (pingStat.videoCallScore > 0) ? pingStat.videoCallScore : 0.0
        newSession.gamingScore = (pingStat.gamingScore > 0) ? pingStat.gamingScore : 0.0
        
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
    
    func delete(session: Sessions) {
        container.viewContext.delete(session)
        save()
    }

}
