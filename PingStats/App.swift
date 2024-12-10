//
//  PingStatsApp.swift
//  PingStats
//
//  Created by Elvis Dorow on 15/07/24.
//

import SwiftUI

@main
struct App: SwiftUI.App {
    
    var settings: Settings = .shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .onAppear {
                    settings.theme = settings.theme
                    insertDefaultHostIfNeeded()
                }
                .tint(.primary)
        }
    }
    
    
    func insertDefaultHostIfNeeded() {
        let db = TargetHostDataService()

        if db.hosts.isEmpty {
            let host = Host()
            host.host = "1.1.1.1"
            host.type = HostType.ip

            db.add(host: host)
        }
    }
}

