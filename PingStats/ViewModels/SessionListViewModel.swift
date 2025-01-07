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
    
    init() {
        sessions = sessionDataService.load()
    }
    
}
