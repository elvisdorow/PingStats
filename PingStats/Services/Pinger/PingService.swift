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
        var config: PingConfiguration = PingConfiguration(
            interval: Double(settings.pingInterval.rawValue) / 1000,
            with: TimeInterval(settings.pingTimeout.rawValue)
        )
        
        config.payloadSize = settings.pingPayload.rawValue - 28
        config.timeToLive = 255
        
        pinger = try? SwiftyPing(host: settings.host, configuration: config, queue: DispatchQueue.global(qos: .default))
        pinger?.observer = { (response) in
            let timeToLive = response.ipHeader?.timeToLive ?? 0
            let iCMPResponse = ICMPResponse(
                sequence: Int(response.sequenceNumber),
                bytes: response.byteCount ?? 0,
                dateTime: Date(),
                timeToLive: Int(timeToLive),
                duration: response.duration,
                error: response.error
            )
            self.response = iCMPResponse
        }
        // give some time to SwiftyPing to its thins before start pinging
        // if it starts right away, the first ping takes considerably longer time
        // afecting the statistics
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            try? self.pinger?.startPinging()
        }
    }
    
    func stop() {
        self.pinger?.haltPinging(resetSequence: true)
        self.pinger = nil
    }

}
