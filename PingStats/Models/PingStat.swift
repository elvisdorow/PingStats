//
//  PingStatModel.swift
//  PingStats
//
//  Created by Elvis Dorow on 25/07/24.
//

import Foundation


class PingStat {
    
    @Published var bestPing: Double
    @Published var worstPing: Double
    @Published var averagePing: Double
    @Published var packageLoss: Double
    @Published var jitter: Double
    
    @Published var generalScore: Double = 0.0
    
    @Published var gamingScore: Double = 0.0
    @Published var videoCallScore: Double = 0.0
    @Published var streamingScore: Double = 0.0
    
    @Published var gamingStatus: Status = .empty
    @Published var videoCallStatus: Status = .empty
    @Published var streamingStatus: Status = .empty
    
    init() {
        self.bestPing = -0.1
        self.worstPing = -0.1
        self.averagePing = -0.1
        self.packageLoss = -0.1
        self.jitter = -0.1
    }
    
    init(best: Double, worst: Double, average: Double, loss: Double, jitter: Double) {
        self.bestPing = best
        self.worstPing = worst
        self.averagePing = average
        self.packageLoss = loss
        self.jitter = jitter
        
        getScore()
        getStatus()
    }
    
    private func getScore() {
        self.gamingScore = calculateScore(pingWeight: 0.55, jitterWeight: 0.2, packageLossWeight: 0.25)
        self.streamingScore = calculateScore(pingWeight: 0.3, jitterWeight: 0.3, packageLossWeight: 0.4)
        self.videoCallScore = calculateScore(pingWeight: 0.2, jitterWeight: 0.5, packageLossWeight: 0.3)
        
        self.generalScore = ((gamingScore + streamingScore + videoCallScore) / 3) - packageLoss
        
        if self.generalScore < 0 {
            self.generalScore = 0
        }
    }
    
    private func calculateStatus(val: Double) -> Status {
        switch val {
        case 0..<25:
            .veryPoor
        case 25..<50:
            .poor
        case 50..<75:
            .acceptable
        case 75..<90:
            .good
        case 90..<101:
            .excellent
        default:
            .empty
        }
    }

    
    private func getStatus() {
        self.gamingStatus = getGamingStatus()
        self.streamingStatus = getStreamingStatus()
        self.videoCallStatus = getVideoCallStatus()
    }

    private func getGamingStatus() -> Status {
        return calculateStatus(val: gamingScore)
    }

    private func getStreamingStatus() -> Status {
        var status: Status = calculateStatus(val: streamingScore)
        
        if status == .poor || status == .             acceptable {
            if packageLoss < 2.0 {
                status = .good
                self.streamingScore = 87
            }
        }

        if status == .good && packageLoss < 1.0 {
            status = .excellent
            self.streamingScore = 100.0
        }

        return status
    }
 
    
    private func getVideoCallStatus() -> Status {
        return calculateStatus(val: videoCallScore)
    }
    
    var pingScore: Double {
        var score = 0.0
        
        switch self.averagePing {
        case ..<21:
            score =  100
        case 20..<30:
            score = 90
        case 30..<50:
            score = 80
        case 50..<70:
            score = 60
        case 70..<100:
            score = 50
        case 100..<150:
            score = 30
        case 150..<200:
            score = 20
        case 200..<300:
            score = 10
        case 300..<500:
            score = 5
        case 500..<1000:
            score = 2
        case 1000..<2000:
            score = 1
        default:
            score = 0
        }

        return score
    }
    
    var jitterScore: Double {
        var score = 0.0
        
        switch self.jitter {
        case ..<5:
            score = 100
        case 5..<10:
            score = 90
        case 10..<15:
            score = 75
        case 15..<20:
            score = 60
        case 20..<25:
            score = 50
        case 25..<30:
            score = 40
        case 30..<40:
            score = 30
        case 40..<50:
            score = 20
        case 50..<70:
            score = 10
        default:
            score = 2
        }

        return score
    }
    
    var packageLossScore: Double {
        var score = 0.0

        switch self.packageLoss {
        case ..<0.1:
            score = 100
        case 0.1..<0.5:
            score = 75
        case 0.5..<1:
            score = 50
        case 1..<2:
            score = 25
        case 2..<5:
            score = 10
        default:
            score = 1
        }
        return score
    }
    
    enum Status: LocalizedStringResource {
        case empty = "---",
             veryPoor = "Bad",
             poor = "Poor",
             acceptable = "Acceptable",
             good = "Good",
             excellent = "Excellent"
    }
    
 
    func calculateScore(pingWeight: Double, jitterWeight: Double, packageLossWeight: Double) -> Double {
        let pingScore = normalizePing(averagePing)
        let jitterScore = normalizeJitter(jitter)
        let packetLossScore = normalizePacketLoss(packageLoss)
        
        let weightedScore = (pingScore * pingWeight) + (jitterScore * jitterWeight) + (packetLossScore * packageLossWeight) - packageLoss
        
        return weightedScore
    }


    // Helper functions to normalize each metric
    func normalizePing(_ ping: Double) -> Double {
        if ping < 32 && jitter < 8 && packageLoss == 0.0 { return 100 }
        else if ping < 35 { return 95 }
        else if ping < 38 { return 93 }
        else if ping < 40 { return 90 }
        else if ping < 42 { return 88 }
        else if ping < 45 { return 85 }
        else if ping < 48 { return 83 }
        else if ping < 50 { return 80 }
        else if ping < 52 { return 78 }
        else if ping < 55 { return 75 }
        else if ping < 58 { return 73 }
        else if ping < 60 { return 70 }
        else if ping < 62 { return 68 }
        else if ping < 65 { return 65 }
        else if ping < 68 { return 63 }
        else if ping < 70 { return 60 }
        else if ping < 72 { return 58 }
        else if ping < 75 { return 55 }
        else if ping < 78 { return 53 }
        else if ping < 80 { return 50 }
        else if ping < 82 { return 48 }
        else if ping < 85 { return 45 }
        else if ping < 88 { return 43 }
        else if ping < 90 { return 40 }
        else if ping < 92 { return 38 }
        else if ping < 95 { return 35 }
        else if ping < 98 { return 33 }
        else if ping < 100 { return 30 }
        else if ping < 105 { return 28 }
        else if ping < 120 { return 25 }
        else if ping < 130 { return 23 }
        else if ping < 150 { return 20 }
        else if ping < 180 { return 15 }
        else if ping < 200 { return 13 }
        else if ping < 300 { return 7 }
        else { return 5 }
    }

    func normalizeJitter(_ jitter: Double) -> Double {
        if jitter < 5 { return 100 }
        else if jitter < 8 { return 95 }
        else if jitter < 10 { return 90 }
        else if jitter < 15 { return 75 }
        else if jitter < 20 { return 50 }
        else if jitter < 25 { return 40 }
        else if jitter < 30 { return 30 }
        else if jitter < 40 { return 20 }

        else { return 10 }
    }

    func normalizePacketLoss(_ packetLoss: Double) -> Double {
        if packetLoss == 0 { return 100 }
        else if packetLoss < 1 { return 80 }
        else if packetLoss < 2 { return 20 }
        else if packetLoss < 5 { return 5 }
        else if packetLoss < 10 { return 3 }
        else if packetLoss < 20 { return 1 }
        else { return 0.1 }
    }

}
