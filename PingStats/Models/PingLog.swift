//
//  LogTextModel.swift
//  PingStats
//
//  Created by Elvis Dorow on 07/08/24.
//

import Foundation

enum PingLogType {
    case good, error
}

struct PingLog: Identifiable, Hashable {
    let id: UUID = UUID()
    let type: PingLogType
    let text: String
}
