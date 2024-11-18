//
//  TargetHost.swift
//  PingStats
//
//  Created by Elvis Dorow on 12/11/24.
//

import Foundation

class TargetHost: Identifiable {
    var id: String = UUID().uuidString
    var ipaddress: String? = nil
    var hostname: String? = nil
}
