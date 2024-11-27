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
//        var config: PingConfiguration = PingConfiguration(
//            interval: Double(settings.pingInterval.rawValue) / 1000,
//            with: TimeInterval(settings.pingTimeout.rawValue)
//        )
        
//        config.payloadSize = settings.pingPayload.rawValue - 28
//        config.timeToLive = 255
        
        let configuration = PingConfiguration(interval: 0.1, with: 3.3)
//        configuration.payloadSize = 1600
        
        pinger = try? SwiftyPing(host: settings.host, configuration: configuration, queue: DispatchQueue.global())

        
        //pinger = try? SwiftyPing(host: settings.host, configuration: config, queue: DispatchQueue.global())
        
        pinger?.observer = {[weak self] response in
            let timeToLive = response.ipHeader?.timeToLive ?? 0
            let iCMPResponse = ICMPResponse(
                sequence: Int(response.trueSequenceNumber),
                bytes: response.byteCount ?? 0,
                dateTime: Date(),
                timeToLive: Int(timeToLive),
                duration: (response.error == nil) ? response.duration : -0.1,
                error: response.error
            )
            self?.response = iCMPResponse
        }
        // give some time to SwiftyPing to its thins before start pinging
        // if it starts right away, the first ping takes considerably longer time
        // afecting the statistics
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
        do {
//            try pinger2?.startPinging()
            try pinger?.startPinging()
        } catch {
            print("Failed to start pinging: \(error.localizedDescription)")
        }
        
        /*
        print("Pinging \(settings.host)")
        var configuration2 = PingConfiguration(interval: 0.1, with: 3.3)
        
        var pinger2 = try? SwiftyPing(host: "8.8.8.8", configuration: configuration2, queue: DispatchQueue.global())
        pinger2?.observer = { response in
            print(response.duration)
        }
        
        do {
            try pinger2?.startPinging()
        } catch let error {
            print(error.localizedDescription)
        }
         */
    }

        
        

    
    func stop() {
        pinger?.haltPinging(resetSequence: true)
        pinger = nil
        response = nil
    }

}
