//
//  SettingsViewModel.swift
//  PingStats
//
//  Created by Elvis Dorow on 09/10/24.
//

import Foundation
import SwiftUI

class SettingsViewModel: ObservableObject {
    

}

enum Theme: Int, CaseIterable, Identifiable {
    case device = 0
    case light = 1
    case dark = 2
    var id: Int { self.rawValue }
    
    var colorScheme: ColorScheme? {
        switch self {
        case .device: return .none
        case .light: return .light
        case .dark: return .dark
        }
    }
    
    var name: String {
        switch self {
        case .device: return String("Device")
        case .light: return String("Light")
        case .dark: return String("Dark")
        }
    }
}

