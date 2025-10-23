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
    
    func get(id: NSManagedObjectID) -> Sessions? {
        do {
            return try container.viewContext.existingObject(with: id) as? Sessions
        } catch {
            print("Error fetching session with id \(id): \(error)")
            return nil
        }
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
    
    func add(session: Session, completion: @escaping (NSManagedObjectID?) -> Void) -> Void {
        // Capture all values that might be accessed during the save operation
        // to avoid accessing the session object from different queue contexts
        let sessionStartDate = session.startDate
        let sessionEndDate = session.endDate
        let sessionHost = session.parameters.host
        let sessionResolvedIpOrHost = session.resolvedIpOrHost
        let sessionConnectionType = session.connectionType
        let sessionElapsedTime = session.elapsedTime
        let sessionPingTimeout = session.parameters.pingTimeout.rawValue
        let sessionPingInterval = session.parameters.pingInterval.rawValue
        let sessionMaxtimeSetting = session.parameters.maxtimeSetting.rawValue
        let sessionResponses = session.responses
        let sessionPingLogs = session.pingLogs
        
        // Only capture the ping stat after checking it exists
        guard let pingStat = session.pingStat else {
            DispatchQueue.main.async {
                completion(nil)
            }
            return
        }
        
        let pingStatBest = pingStat.bestPing
        let pingStatWorst = pingStat.worstPing
        let pingStatJitter = pingStat.jitter
        let pingStatAverage = pingStat.averagePing
        let pingStatPackageLoss = pingStat.packageLoss
        let pingStatGeneralScore = (pingStat.generalScore > 0) ? pingStat.generalScore : 0.0
        let pingStatStreamingScore = (pingStat.streamingScore > 0) ? pingStat.streamingScore : 0.0
        let pingStatVideoCallScore = (pingStat.videoCallScore > 0) ? pingStat.videoCallScore : 0.0
        let pingStatGamingScore = (pingStat.gamingScore > 0) ? pingStat.gamingScore : 0.0
        
        let context = container.viewContext
        
        context.perform {
            let newSession: Sessions = Sessions(context: context)
            
            newSession.startDate = sessionStartDate
            newSession.endDate = sessionEndDate
            newSession.host = sessionHost
            newSession.resolvedIpOrHost = sessionResolvedIpOrHost
            
            newSession.connectionType = sessionConnectionType
            
            newSession.bestPing = pingStatBest
            newSession.worstPing = pingStatWorst
            newSession.jitter = pingStatJitter
            newSession.averagePing = pingStatAverage
            newSession.packageLoss = pingStatPackageLoss
            
            newSession.generalScore = pingStatGeneralScore
            newSession.streamingScore = pingStatStreamingScore
            newSession.videoCallScore = pingStatVideoCallScore
            newSession.gamingScore = pingStatGamingScore
            
            newSession.pingCount = Int16(sessionResponses.count)
            
            newSession.elapsedTime = sessionElapsedTime
            
            newSession.pingTimeout = Int16(sessionPingTimeout)
            newSession.pingInterval = Int16(sessionPingInterval)
            newSession.maxtimeSetting = Int16(sessionMaxtimeSetting)
            
            var logs: [SessionLog] = []
            for pingLog in sessionPingLogs {
                let sessionLog = SessionLog(context: context)
                sessionLog.sequence = Int32(pingLog.sequence)
                sessionLog.bytes = Int32(pingLog.bytes)
                sessionLog.duration = pingLog.duration
                sessionLog.timeToLive = Int32(pingLog.timeToLive)
                sessionLog.dateTime = pingLog.dateTime
                sessionLog.error = pingLog.error
                
                logs.append(sessionLog)
            }
            newSession.logs = NSOrderedSet(array: logs)
            
            do {
                try context.save()
                let objectID = newSession.objectID
                // Update the published property on the main queue
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.sessions = self.load() // Update @Published
                    completion(objectID)
                }
            } catch {
                AnalyticsService.instance.logEvent(name: "save_session_error", parameters: ["error": error.localizedDescription, "session": session])
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
    func delete(session: Sessions) {
        container.viewContext.delete(session)
        save()
    }

}
