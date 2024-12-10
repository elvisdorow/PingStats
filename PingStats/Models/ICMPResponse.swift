//
//  PingResponse.swift
//  PingStats
//
//  Created by Elvis Dorow on 15/07/24.
//

import Foundation
import SwiftyPing

struct ICMPResponse: Identifiable {
    let id: UUID = UUID()
    let sequence: Int
    let bytes: Int
    let dateTime: Date
    let timeToLive: Int
    let ipv4Address: String?
    let duration: TimeInterval
    let error: PingError?
}
