//
//  AnalyticsService.swift
//  PingStats
//
//  Created by Elvis Dorow on 24/01/25.
//

import Foundation
import FirebaseAnalytics

class AnalyticsService {
    static let instance = AnalyticsService()

    private init() {}

    // Log a custom event to Firebase Analytics
    func logEvent(name: String, parameters: [String: Any]? = nil) {
        Analytics.logEvent(name, parameters: parameters)
    }

    // Example: Log a "button_clicked" event
    func logButtonClicked(buttonName: String) {
        let parameters: [String: Any] = [
            "button_name": buttonName,
            "timestamp": Date().timeIntervalSince1970
        ]
        logEvent(name: "button_clicked", parameters: parameters)
    }

    // Example: Log a "screen_view" event
//    func logScreenView(screenName: String, screenClass: String) {
//        Analytics.logEvent(AnalyticsEventScreenView, parameters: [
//            AnalyticsParameterScreenName: screenName,
//            AnalyticsParameterScreenClass: screenClass
//        ])
//    }
}
