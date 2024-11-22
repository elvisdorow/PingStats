//
//  SessionResult.swift
//
//  Created by Elvis Dorow on 11/09/24.
//

import Foundation

class Session {
    
    let parameters: SessionParam
    var connectionType: String
    
    var pingStat: PingStat? = nil
    
    private(set) var responses: [ICMPResponse]
    private(set) var pingLogs: [PingLog]
    
    let startDate: Date
    var endDate: Date?
    var elapsedTime: TimeInterval
    
    init(_ params: SessionParam) {
        parameters = params
        startDate = Date()
        endDate = nil
        elapsedTime = 0
        responses = []
        pingLogs = []
        connectionType = ""
    }
    
    func addResponse(_ response: ICMPResponse) -> PingLog {
        responses.append(response)
        return addPingLog(response)
    }
    
    func getPingStat() -> PingStat {
        let numResponses = (parameters.pingCountStat == .countAll)
        ? responses.count : parameters.pingCountStat.rawValue
        
        var average = 0.0
        var best = 0.0
        var worst = 0.0
        var loss = 0.0
        var jitter = 0.0
        
        let lastResponses = responses.suffix(numResponses)
        
        let lastRoudtripTimes = lastResponses.map { $0.duration }
        let allRoudtripTimes = responses.map { $0.duration }
        
        if lastRoudtripTimes.count != 0, let min = allRoudtripTimes.min(), let max = allRoudtripTimes.max() {
            let count = Double(lastRoudtripTimes.count)
            let total = lastRoudtripTimes.reduce(0, +)
            let avg = total / count
            let variance = lastRoudtripTimes.reduce(0, { $0 + ($1 - avg) * ($1 - avg) })
            let stddev = sqrt(variance / count)
            
            average = avg.scaled(by: 1000.0)
            jitter = stddev.scaled(by: 1000.0)
            
            best = min.scaled(by: 1000.0)
            worst = max.scaled(by: 1000.0)
        }
        
        let lost = responses.filter{ $0.error != nil }.count
        let lossPercentage = (Double(lost) / Double(responses.count) * 100)
        loss = lossPercentage
        
        let pingStat: PingStat = .init(
            best: best,
            worst: worst,
            average: average,
            loss: loss,
            jitter: jitter)
        
        self.pingStat = pingStat
        
        return pingStat
    }
    
    private func addPingLog(_ response: ICMPResponse) -> PingLog {
//        let sequence = response.sequence - Settings.shared.dropFirst
        let sequence = response.sequence
        
        if let error = response.error {
            let log = PingLog(sequence: sequence, error: error.localizedDescription)
            pingLogs.append(log)
            return log
        } else {
            let responseTime = response.duration * 1000
            
            let log = PingLog(
                sequence: sequence,
                bytes: response.bytes,
                timeToLive: response.timeToLive,
                duration: responseTime)
            
            pingLogs.append(log)
            return log
        }
    }
}
