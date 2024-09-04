//
//  Theme.swift
//  PingStats
//
//  Created by Elvis Dorow on 03/09/24.
//

import Foundation

enum Theme: String, CaseIterable, Identifiable {
    case system = "Device"
    case lightMode = "Light"
    case darkMode = "Dark"
    
    var id: String { self.rawValue }
}
