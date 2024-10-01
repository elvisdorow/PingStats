//
//  SettingsViewModel.swift
//  PingStats
//
//  Created by Elvis Dorow on 03/09/24.
//

import Foundation
import SwiftUI

class SettingsViewModel: ObservableObject {

    @Published var settingsModel: SettingsModel = .shared
    
    init() {
//        self.settingsModel = SettingsModel.shared
    }
    
    /*
    @AppStorage("theme") var theme: Theme = .system
    
    @AppStorage("pingInterval") var pingInterval: PingInterval = .sec1
    @AppStorage("pingCountStat") var pingCountStat: PingCountStat = .count30
    @AppStorage("pingMaxtime") var maxtimeSetting: PingMaxtime = .min5
    @AppStorage("pingTimeout") var pingTimeout: PingTimeout = .sec1 

    @AppStorage("selectedIpAddress") var selectedIpAddress: String = "1.1.1.1"

    // Store the array as Data
    @AppStorage("ipAddressesData") var ipAddressesData: Data = Data()
    
    @Published var showAddForm: Bool = false
    @Published var addFormError: String = ""
    @Published var newIpAddress: String = ""
    
    var ipAddresses: [String] {
        get {
            // Deserialize the Data back to an array of Strings
            if let savedArray = try? JSONDecoder().decode([String].self, from: ipAddressesData) {
                return savedArray
            }
            return [
                "1.1.1.1",
                "8.8.8.8",
                "8.8.4.4"
            ]
        }
        set {
            // Serialize the array to Data
            if let encoded = try? JSONEncoder().encode(newValue) {
                ipAddressesData = encoded
            }
        }
    }
    
    */
    

}
