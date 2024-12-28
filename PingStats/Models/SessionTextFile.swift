//
//  SessionTextFile.swift
//  PingStats
//
//  Created by Elvis Dorow on 27/12/24.
//

import Foundation

struct SessionTextFile: Codable {
    
    let startDate: Date
    let endDate: Date
    let host: String
    let resolvedIpOrHost: String
    
    let connectionType: String
    
    let bestPing: Double
    let worstPing: Double
    let jitter: Double
    let averagePing: Double
    let packageLoss: Double
    
    let pingCount: Int16
    let elapsedTime: Double
    
    let pingTimeout: String
    let pingInterval: String
    let maxtimeSetting: String
    
    let logs: [PingLogTextFile]
}

struct PingLogTextFile: Codable {
    let dateTime: Date
    let sequence: Int
    let bytes: Int
    let timeToLive: Int
    let duration: Double
    let error: String?
}
