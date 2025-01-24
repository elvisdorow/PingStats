//
//  ResultViewModel.swift
//  PingStats
//
//  Created by Elvis Dorow on 11/09/24.
//

import Foundation

class SessionListViewModel: ObservableObject {
    
    private var sessionDataService: SessionDataService = .instance
    
    @Published var sessions: [Sessions] = []
    
    var selectedSession: Sessions?
    
    init() {
        sessions = sessionDataService.load()
    }
    
    
    func deleteSession() {
        guard let session = selectedSession else { return }
        FileService.instance.deleteSessionFile(session: session)
        sessionDataService.delete(session: session)
        
        sessions = sessionDataService.load()
        
        AnalyticsService.instance.logEvent(name: "session_deleted")
    }

}
