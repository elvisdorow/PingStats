//
//  MeasurementResult.swift
//  PingStats
//
//  Created by Elvis Dorow on 11/09/24.
//

import Foundation

import RealmSwift

final class MeasurementResult: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id = ObjectId.generate()

    @Persisted var dateStart: Date
    @Persisted var dateEnd: Date
    @Persisted var ipAddress: String
    @Persisted var hostAddress: String
    
    @Persisted var bestPing: Double
    @Persisted var worstPing: Double
    @Persisted var avaragePing: Double
    @Persisted var packageLoss: Double
    @Persisted var jitter: Double
    @Persisted var pingCount: Int
    
    @Persisted var generalNetQuality: Double
    
    @Persisted var gamingScore: Double
    @Persisted var streamingScore: Double
    @Persisted var videoCallScore: Double
    
    @Persisted var pingInterval: Int
    @Persisted var maxtimeSetting: Int
    @Persisted var pingTimeout: Int

    
    var elapsedTime: String {
        get {
            let elapsedTime = self.dateEnd.timeIntervalSince(self.dateStart)
            return Formatter.elapsedTime(elapsedTime)
        }
    }
    
    func fromModel(model: MeasurementModel) {
        self.dateStart = model.dateStart ?? Date()
        self.dateEnd = model.dateEnd ?? Date()
        self.ipAddress = model.ipAddress ?? ""
        self.hostAddress = model.hostAddress ?? ""
        self.bestPing = model.bestPing
        self.worstPing = model.worstPing
        self.avaragePing = model.avaragePing
        self.packageLoss = model.packageLoss
        self.jitter = model.jitter
        self.generalNetQuality = model.generalNetQuality
        self.pingCount = model.responses.count
    }


    static let example: MeasurementResult = {
        let result = MeasurementResult()
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
        return result
    }()

}

