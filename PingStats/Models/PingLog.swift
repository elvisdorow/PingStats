//
//  LogTextModel.swift
//  PingStats
//
//  Created by Elvis Dorow on 07/08/24.
//

import Foundation

struct PingLog: Identifiable, Hashable {
    let id: UUID
    let dateTime: Date
    let sequence: Int
    let bytes: Int
    let timeToLive: Int
    let duration: Double
    let error: String?
    
    init(sequence: Int, error: String) {
        self.sequence = sequence
        self.error = error
        self.id = UUID()
        self.dateTime = Date()
        self.timeToLive = 0
        self.bytes = 0
        self.duration = 0
    }
    
    init(id: UUID = UUID(), date: Date = Date(), sequence: Int, bytes: Int, timeToLive: Int, duration: Double) {
        self.id = id
        self.dateTime = date
        self.sequence = sequence
        self.bytes = bytes
        self.timeToLive = timeToLive
        self.duration = duration
        self.error = nil
    }
}
