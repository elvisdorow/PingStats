//
//  IPValidator.swift
//  PingStats
//
//  Created by Elvis Dorow on 30/09/24.
//

import Foundation


enum IpValidationError: Error {
    case invalid
    case emptyValue
}

class IPValidator {
    
    static func isValidIPv4(_ address: String) -> Bool {
        let parts = address.split(separator: ".")
        guard parts.count == 4 else { return false }
        
        for part in parts {
            guard let number = Int(part), number >= 0 && number <= 255 else {
                return false
            }
        }
        
        return true
    }

    static func isValidHostname(_ hostname: String) -> Bool {
        let hostnameRegex = "^[A-Za-z0-9-]{1,63}(\\.[A-Za-z0-9-]{1,63})*$"
        let hostnameTest = NSPredicate(format: "SELF MATCHES %@", hostnameRegex)
        return hostnameTest.evaluate(with: hostname)
    }

    static func validateIPAddressOrHostname(_ input: String) -> Bool {
        return isValidIPv4(input) || isValidHostname(input)
    }
    
}
