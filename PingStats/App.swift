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
                }
                .tint(.primary)
        }
    }
}

