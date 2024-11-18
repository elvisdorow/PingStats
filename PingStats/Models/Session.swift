//
//  SessionResult.swift
//
//  Created by Elvis Dorow on 11/09/24.
//

import Foundation

class Session {
    
    let parameters: SessionParam
    var pingStat: PingStat? = nil
    
    private(set) var responses: [ICMPResponse]
    private(set) var pingLogs: [PingLog]

    let startDate: Date
    
    init(_ params: SessionParam) {
        parameters = params
        startDate = Date()
        responses = []
        pingLogs = []
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
        
        return .init(
            best: best,
            worst: worst,
            average: average,
            loss: loss,
            jitter: jitter)
    }
    
    private func addPingLog(_ response: ICMPResponse) -> PingLog {        
        if response.error != nil {
            let log = PingLog(type: .error, text: "error")
            pingLogs.append(log)
            return log
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm:ss"
            
            let responseTime = response.duration * 1000
            
            let logText: String = "\(dateFormatter.string(from: Date()))\t icmp_seq=\(response.sequence)\t ttl=55 \t time=\(String(format: "%.0f", responseTime)) ms"
            
            let log = PingLog(type: .good, text: logText)
            pingLogs.append(log)
            return log
        }
    }
}


/*
var dateStart: Date
var dateEnd: Date
var ipAddress: String
var hostAddress: String

var bestPing: Double
var worstPing: Double
var avaragePing: Double
var packageLoss: Double
var jitter: Double
var pingCount: Int

var generalNetQuality: Double

var gamingScore: Double
var streamingScore: Double
var videoCallScore: Double

var pingInterval: Int
var maxtimeSetting: Int
var pingTimeout: Int

var connectionType: String

var elapsedTime: String {
    get {
        let elapsedTime = self.dateEnd.timeIntervalSince(self.dateStart)
        return Formatter.elapsedTime(elapsedTime)
    }
}

func fromModel(model: PingStat) {
//        self.ipAddress = model.host
//        self.hostAddress = model.hostname ?? ""
    self.bestPing = model.bestPing
    self.worstPing = model.worstPing
    self.avaragePing = model.averagePing
    self.packageLoss = model.packageLoss
    self.jitter = model.jitter
    self.generalNetQuality = model.generalScore
//        self.pingCount = model.responses.count
//        self.connectionType = model.connectionType.rawValue
}


static let example: SessionResult = {
    let result = SessionResult()
    result.dateStart = Date().addingTimeInterval(-116)
    result.dateEnd = Date()
    result.ipAddress = "1.1.1.1"
    result.hostAddress = "dns.google"
    result.bestPing = 28.9
    result.worstPing = 30.3
    result.avaragePing = 29.6
    result.packageLoss = 0.0
    result.jitter = 0.3
    result.generalNetQuality = 90.0
    result.gamingScore = 80.0
    result.streamingScore = 85.0
    result.videoCallScore = 95.0
    result.connectionType = ConnectionType.wifi.rawValue
    return result
}()
 
 */

