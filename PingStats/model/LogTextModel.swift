//
//  LogTextModel.swift
//  PingStats
//
//  Created by Elvis Dorow on 07/08/24.
//

import Foundation

enum LogType {
    case good, error
}

struct LogTextModel: Identifiable, Hashable {
    let id: UUID = UUID()
    let type: LogType
    let text: String
}
