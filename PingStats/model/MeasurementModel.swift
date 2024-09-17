//
//  PingStatModel.swift
//  PingStats
//
//  Created by Elvis Dorow on 25/07/24.
//

import Foundation


struct MeasurementModel: Identifiable {
    
    let id: String = UUID().uuidString
    var dateStart: Date?
    var dateEnd: Date?
    var ipAddress: String?
    var hostAddress: String?
    
    var bestPing: Double = -0.1
    var worstPing: Double = -0.1
    var avaragePing: Double = -0.1
    var packageLoss: Double = -0.1
    var jitter: Double = -0.1
    var elapsedTime: TimeInterval?
    
    var generalNetQuality: Double = 0.0
    
    var gamingStatus: Status = .empty
    var streamingStatus: Status = .empty
    var videoCallStatus: Status = .empty
    
    var gamingScore: Double = 0.0
    var streamingScore: Double = 0.0
    var videoCallScore: Double = 0.0
    
    var responses: [PingStatResponse] = []
    
    init() {
        dateStart = nil
        dateEnd = nil
        ipAddress = nil
        hostAddress = nil        
    }
    
    enum Status: String {
        case empty = "---",
             veryBad = "Very Bad",
             bad = "Bad",
             normal = "Normal",
             good = "Good",
             excelent = "Excelent"
    }
    
}

struct PingChartItem: Identifiable {
    let id = UUID()
    let sequency: Int
    var duration: Double
}
