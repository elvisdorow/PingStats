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
    let dateTime: Date
    let duration: TimeInterval
    let error: PingError?
}
