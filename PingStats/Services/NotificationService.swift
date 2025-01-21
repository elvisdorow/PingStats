//
//  NotificationService.swift
//  PingStats
//
//  Created by Elvis Dorow on 20/01/25.
//

import Foundation
import NotificationCenter

class NotificationService {
   static let instance = NotificationService()
    
    private init() {}
    
    func checkNotificationPermission() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
                switch settings.authorizationStatus {
                case .notDetermined:
                    // First-time request
                    self.requestNotificationPermission()
                case .denied:
                    print("Notifications denied")
                case .authorized, .provisional, .ephemeral:
                    // Notifications are enabled
                    print("Notifications are already authorized.")
                @unknown default:
                    break
                }
            }
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Error requesting notification permission: \(error.localizedDescription)")
            } else if granted {
                print("Permission granted!")
            } else {
                print("Permission denied.")
            }
        }
    }
    
    func sendAppInBackgroundNotification(completionHandler: @escaping (_ scheduled: Bool) -> Void ) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized ||
               settings.authorizationStatus == .provisional ||
               settings.authorizationStatus == .ephemeral {
                
                // Create the notification content
                let content = UNMutableNotificationContent()
                content.title = String(localized: "Ping Test Paused")
                content.body = String(localized: "The test paused as the app moved to the background. Open the app to resume.")
                content.sound = .default

                // Set a trigger for the notification (e.g., after 5 seconds)
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

                // Create the notification request
                let request = UNNotificationRequest(
                    identifier: UUID().uuidString,
                    content: content,
                    trigger: trigger
                )

                // Add the notification request
                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        print("Error adding notification: \(error.localizedDescription)")
                        completionHandler(false)
                    } else {
                        print("Notification scheduled successfully.")
                        completionHandler(true)
                    }
                }
            } else {
                print("Notification permissions are not granted.")
                completionHandler(false)
            }
        }
    }

    
}
