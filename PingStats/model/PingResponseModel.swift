//
//  PingResponse.swift
//  PingStats
//
//  Created by Elvis Dorow on 15/07/24.
//

import Foundation
import SwiftyPing

struct PingStatResponse: Identifiable {
    let id: String = UUID().uuidString
    let sequency: Int
    let dateTime: Date
    let duration: TimeInterval
    let error: PingError?
}
