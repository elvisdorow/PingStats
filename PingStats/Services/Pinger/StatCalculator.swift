//
//  StatsCalculator.swift
//  PingStats
//
//  Created by Elvis Dorow on 14/11/24.
//

import Foundation

struct StatCalculator {
    
    static func getInstantStat(responses: [ICMPResponse], responsesCount: Int) -> PingStat {
        let lastResponses = responses.suffix(responsesCount)
        return calcStat(responses: Array(lastResponses))
    }
    
    static func getFullTestPingStat(responses: [ICMPResponse]) -> PingStat {
        return calcStat(responses: responses)
    }
    
    private static func calcStat(responses: [ICMPResponse]) -> PingStat {
        var average = 0.0
        var best = 0.0
        var worst = 0.0
        var loss = 0.0
        var jitter = 0.0
        
        let roundTripTimes = responses.map { $0.duration }
        
        if roundTripTimes.count != 0, let min = roundTripTimes.min(), let max = roundTripTimes.max() {
            let count = Double(roundTripTimes.count)
            let total = roundTripTimes.reduce(0, +)
            let avg = total / count
            let variance = roundTripTimes.reduce(0, { $0 + ($1 - avg) * ($1 - avg) })
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
        
        return pingStat
    }

}
