//
//  SettingsViewModel.swift
//  PingStats
//
//  Created by Elvis Dorow on 03/09/24.
//

import Foundation
import SwiftUI

enum IpValidationError: Error {
    case invalid
    case emptyValue
}

class SettingsViewModel: ObservableObject {
    @AppStorage("theme") var theme: Theme = .system
    @AppStorage("pingInterval") var pingInterval: Double = 1.0
    @AppStorage("pingSample") var pingSample: Double = 60.0
    @AppStorage("maxPingCount") var maxPingCount: Double = 120.0

    @AppStorage("selectedIpAddress") var selectedIpAddress: String = "1.1.1.1"

    // Store the array as Data
    @AppStorage("ipAddressesData") private var ipAddressesData: Data = Data()
            
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
    
    
    
    func isValidIPv4(_ address: String) -> Bool {
        let parts = address.split(separator: ".")
        guard parts.count == 4 else { return false }
        
        for part in parts {
            guard let number = Int(part), number >= 0 && number <= 255 else {
                return false
            }
        }
        
        return true
    }

    func isValidHostname(_ hostname: String) -> Bool {
        let hostnameRegex = "^[A-Za-z0-9-]{1,63}(\\.[A-Za-z0-9-]{1,63})*$"
        let hostnameTest = NSPredicate(format: "SELF MATCHES %@", hostnameRegex)
        return hostnameTest.evaluate(with: hostname)
    }

    func validateIPAddressOrHostname(_ input: String) -> Bool {
        return isValidIPv4(input) || isValidHostname(input)
    }

}
