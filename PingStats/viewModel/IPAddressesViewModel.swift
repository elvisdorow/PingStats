//
//  IPAddressesViewModel.swift
//  PingStats
//
//  Created by Elvis Dorow on 30/09/24.
//

import Foundation


import SwiftUI

class IPAddressesViewModel: ObservableObject {
    
    @Published var settingsModel: Settings
    
    init() {
        self.settingsModel = Settings.shared
    }
    
    
}
