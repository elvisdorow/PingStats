//
//  Network.swift
//  PingStats
//
//  Created by Elvis Dorow on 15/07/24.
//

import Foundation
import SwiftyPing

class NetworkTester: ObservableObject {
    
    private var pinger: SwiftyPing?
    
    var responses: [PingResponse] = []
    
    var errors: [PingError] = []
    private var counter: Int = 0
    
    @Published var avarage: Int = 0
    @Published var count: Int = 0
    @Published var jitter: Int = 0
    @Published var min: Int = 0
    @Published var max: Int = 0
    @Published var loss: Double = 0.0
    
    @Published var logs: [String] = []
    
    func start() {
        responses.removeAll()
        errors.removeAll()

        if logs.count > 0 {
            logs.removeSubrange(1..<logs.count)
        }
            
        var config: PingConfiguration = PingConfiguration(interval: 1.0, with: 5)
        config.payloadSize = 64
        config.timeToLive = 55

        pinger = try? SwiftyPing(host: "yahoo.com", configuration: config, queue: DispatchQueue.global())
        
        // Ping indefinitely
        pinger?.observer = { (response) in
            self.counter += 1
            
            // Test network error
            if self.counter == 4 {
                self.errors.append(PingError.requestTimeout)
            } else {
                if let error = response.error {
                    self.addError(error: error)
                } else {
                    self.addResponse(response: response)
                }
            }
                        
        }
        try? pinger?.startPinging()
        
        pinger?.finished = { result in
//            print(result.roundtrip)
        }
            
    }
    
    func stop() {
        pinger?.haltPinging(resetSequence: true)
        counter = 0
    }
    
    func addError(error: PingError) {
        errors.append(error)
        calculateStats()
    }
    
    func addResponse(response: PingResponse) {
        responses.append(response)
        calculateStats()
    }
    
    func calculateStats() {
        print("Calculating stats...")
        
        let roundtripTimes = responses.map { $0.duration }
        if roundtripTimes.count != 0, let min = roundtripTimes.min(), let max = roundtripTimes.max() {
            let count = Double(roundtripTimes.count)
            let total = roundtripTimes.reduce(0, +)
            let avg = total / count
            let variance = roundtripTimes.reduce(0, { $0 + ($1 - avg) * ($1 - avg) })
            let stddev = sqrt(variance / count)
            
            self.avarage = Int(avg.scaled(by: 1000.0))
            self.count = Int(count)
            self.jitter = Int(stddev.scaled(by: 1000.0))
            
            self.min = Int(min.scaled(by: 1000.0))
            self.max = Int(max.scaled(by: 1000.0))

            let logItem: String = "\(self.counter) - \(self.min) - \(self.max) - \(self.avarage) - \(self.jitter)"

            self.logs.append(logItem)
        }
        
        let lost = errors.count
        let lossPercentage = (Double(lost) / Double(counter) * 100)
        self.loss = lossPercentage
    }
}
