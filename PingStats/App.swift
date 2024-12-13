//
//  PingStatsApp.swift
//  PingStats
//
//  Created by Elvis Dorow on 15/07/24.
//

import SwiftUI

@main
struct App: SwiftUI.App {
    
    @AppStorage("isFirstTime") private var isFirstTime: Bool = true
    
    var settings: Settings = .shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .onAppear {
                    settings.theme = settings.theme
                    insertDefaultHostIfNeeded()
                }
                .tint(Color.theme.accent)
        }
    }
    
    
    func insertDefaultHostIfNeeded() {
        if isFirstTime {
            let db = TargetHostDataService()

            if db.hosts.isEmpty {
                let host = Host()
                host.host = "1.1.1.1"
                host.type = HostType.ip

                db.add(host: host)
            }            
            isFirstTime = false
        }
    }
}

