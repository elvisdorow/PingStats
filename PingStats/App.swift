//
//  PingStatsApp.swift
//  PingStats
//
//  Created by Elvis Dorow on 15/07/24.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct App: SwiftUI.App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @AppStorage("isFirstTime") private var isFirstTime: Bool = true
    
    var settings: Settings = .shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .onAppear {
                    settings.theme = settings.theme
                    initialSetup()
                }
                .tint(Color.theme.accent)
        }
    }
    
    
    func initialSetup() {
        if isFirstTime {
            // setup database
            let db = TargetHostDataService()

            if db.hosts.isEmpty {
                let host = Host()
                host.host = "1.1.1.1"
                host.type = HostType.ip

                db.add(host: host)
            }
            
            // ask for notification permission
            NotificationService.instance.checkNotificationPermission()
            
            isFirstTime = false
        }
    }
    
}

