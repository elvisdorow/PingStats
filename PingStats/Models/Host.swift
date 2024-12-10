//
//  Host.swift
//  PingStats
//
//  Created by Elvis Dorow on 28/11/24.
//

import Foundation

class Host: Identifiable {
    var id: String = UUID().uuidString
    var type: HostType = .name
    var host: String = ""
}

enum HostType: String {
    case ip = "ip"
    case name = "name"
}
