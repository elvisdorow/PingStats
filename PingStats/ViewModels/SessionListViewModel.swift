//
//  ResultViewModel.swift
//  PingStats
//
//  Created by Elvis Dorow on 11/09/24.
//

import Foundation
import Combine

class SessionListViewModel: ObservableObject {
    
    private var sessionDataService: SessionDataService = .instance
    
    @Published var sessions: [Sessions] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        sessionDataService.$sessions.sink {[weak self] sessionsList in
            print("session list changed")
            for session in sessionsList {
                if let self = self {
                    self.sessions.append(session)
                }
            }
        }
        .store(in: &cancellables)
        
        sessionDataService.load()
    }
    
}
