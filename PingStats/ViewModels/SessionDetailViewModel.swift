//
//  SessionDetailViewModel.swift
//  PingStats
//
//  Created by Elvis Dorow on 27/12/24.
//

import SwiftUI

class SessionDetailViewModel: ObservableObject {
    
    let session: Sessions
    
    var fileURL: URL?
    
    private var sessionDataService: SessionDataService = .instance
        
    init(session: Sessions) {
        self.session = session
    }
    
    func saveSessionToFile() {
        do {
            fileURL = try FileService.instance.saveSession(session: session)            
            AnalyticsService.instance.logEvent(name: "session_saved_detail_view")
        } catch {
            print("Error saving session to file: \(error)")
        }
    }
    
    func shareSession() {
        do {
            fileURL = try FileService.instance.saveSession(session: session)
            AnalyticsService.instance.logEvent(name: "session_shared_detail_view")
        } catch {
            print("Error sharing session: \(error)")
        }
    }
    
    func deleteSession() {
        FileService.instance.deleteSessionFile(session: session)
        sessionDataService.delete(session: session)
        
        AnalyticsService.instance.logEvent(name: "session_deleted_from_detail_view")
    }
}
