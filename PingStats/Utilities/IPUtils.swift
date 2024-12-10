//
//  IPValidator.swift
//  PingStats
//
//  Created by Elvis Dorow on 30/09/24.
//

import Foundation
import SwiftyPing

enum IpValidationError: Error {
    case invalid
    case emptyValue
}

class IPUtils {
    
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
    
    static func resolveHostname(for ipAddress: String, completion: @escaping (String?) -> Void) {
        var hints = addrinfo(
            ai_flags: AI_NUMERICHOST,
            ai_family: AF_UNSPEC,
            ai_socktype: SOCK_STREAM,
            ai_protocol: IPPROTO_TCP,
            ai_addrlen: 0,
            ai_canonname: nil,
            ai_addr: nil,
            ai_next: nil
        )
        
        var res: UnsafeMutablePointer<addrinfo>?
        
        let status = getaddrinfo(ipAddress, nil, &hints, &res)
        
        if status == 0, let result = res {
            defer { freeaddrinfo(result) }
            
            var hostnameBuffer = [CChar](repeating: 0, count: Int(NI_MAXHOST))
            
            let getnameinfoStatus = getnameinfo(
                result.pointee.ai_addr,
                socklen_t(result.pointee.ai_addrlen),
                &hostnameBuffer,
                socklen_t(hostnameBuffer.count),
                nil,
                0,
                NI_NAMEREQD
            )
            
            if getnameinfoStatus == 0 {
                let hostname = String(cString: hostnameBuffer)
                completion(hostname)
                return
            }
        }
        completion(nil)
    }

    static func resolveHostname(for ipAddress: String) async -> String? {
        return await withCheckedContinuation { continuation in
            resolveHostname(for: ipAddress) { hostname in
                continuation.resume(returning: hostname)
            }
        }
    }
}
