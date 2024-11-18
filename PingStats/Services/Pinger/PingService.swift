//
//  PingerManager.swift
//  PingStats
//
//  Created by Elvis Dorow on 12/11/24.
//

import Foundation
import SwiftyPing

class PingService {
    
    static let instance = PingService()
    private init() { }
    
    private var pinger: SwiftyPing?
    
    @Published var response: ICMPResponse?
    
    private var settings: Settings = Settings.shared
    
    func start() {
        let config: PingConfiguration = PingConfiguration(
            interval: Double(settings.pingInterval.rawValue) / 1000,
            with: TimeInterval(settings.pingTimeout.rawValue))
        
        pinger = try? SwiftyPing(host: settings.host, configuration: config, queue: DispatchQueue.global())
        
        var sequence = 0
        pinger?.observer = { (response) in
            sequence += 1
            let iCMPResponse = ICMPResponse(
                sequence: sequence,
                dateTime: Date(),
                duration: response.duration,
                error: response.error
            )
            self.response = iCMPResponse
        }
        try? pinger?.startPinging()
    }
    
    func stop() {
        self.pinger?.haltPinging(resetSequence: true)
        self.pinger = nil
    }

}
