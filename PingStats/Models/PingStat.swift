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
    
    @Published var generalScore: Double = -0.1
    
    @Published var gamingScore: Double = -0.1
    @Published var videoCallScore: Double = -0.1
    @Published var streamingScore: Double = -0.1
    
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
        self.generalScore = (pingScore + jitterScore + packageLossScore) / 3
        
        // TODO - improve algorithm
        self.gamingScore = self.generalScore
        self.streamingScore = self.generalScore
        self.videoCallScore = self.generalScore

    }
    
    private func getStatus() {
        self.gamingStatus = getGamingStatus()
        self.streamingStatus = getStreamingStatus()
        self.videoCallStatus = getVideoCallStatus()
    }

    private func getGamingStatus() -> Status {
        switch generalScore {
        case 0..<20:
            .veryBad
        case 20..<70:
            .bad
        case 70..<85:
            .average
        case 85..<95:
            .good
        case 95..<101:
            .excelent
        default:
            .empty
        }
    }

    private func getStreamingStatus() -> Status {
        var status: Status = .empty
        
        switch streamingScore {
        case 0..<44:
            status = .bad
        case 58..<75:
            status = .average
        case 75..<83:
            status = .good
        default:
            status = .excelent
        }
        
        if status == .bad || status == .average {
            if packageLoss < 2.0 {
                status = .good
                self.streamingScore = 87
            }
        }

        if status == .good && packageLoss < 1.0 {
            status = .excelent
            self.streamingScore = 100.0
        }

        return status
    }
    
    private func getVideoCallStatus() -> Status {
        switch videoCallScore {
            case 0..<53:
                .veryBad
            case 53..<65:
                .bad
            case 65..<77:
                .average
            case 77..<87:
                .good
            case 87..<101:
                .excelent
            default:
                .empty
        }
    }
    
    // MARK: Computed properties
    
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
        default:
            score = 10
        }
        return score
    }
    
    enum Status: String {
        case empty = "---",
             veryBad = "Very Bad",
             bad = "Bad",
             average = "Average",
             good = "Good",
             excelent = "Excelent"
    }
}
