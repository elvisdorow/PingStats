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
        
        if settings.hostType == HostType.name.rawValue {
            pinger = try? SwiftyPing(host: settings.host, configuration: config, queue: DispatchQueue.global())
            print("pinging host \(settings.host)")
        } else {
            pinger = try? SwiftyPing(ipv4Address: settings.host, config: config, queue: DispatchQueue.global())
            print("pinging ip \(settings.host)")
        }
        
        pinger?.observer = {[weak self] response in
            let timeToLive = response.ipHeader?.timeToLive ?? 0
            let iCMPResponse = ICMPResponse(
                sequence: Int(response.trueSequenceNumber),
                bytes: response.byteCount ?? 0,
                dateTime: Date(),
                timeToLive: Int(timeToLive),
                ipv4Address: response.ipAddress,
                duration: (response.error == nil) ? response.duration : -0.1,
                error: response.error
            )
            self?.response = iCMPResponse
         }

        // give some time to SwiftyPing to its thins before start pinging
        // if it starts right away, the first ping takes considerably longer time
        // afecting the statistics
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            do {
                try self.pinger?.startPinging()
            } catch {
                print("Failed to start pinging: \(error.localizedDescription)")
            }
        }
    }
    
    func stop() {
        pinger?.haltPinging(resetSequence: true)
        pinger = nil
        response = nil
    }
    
    func pause() {
        pinger?.stopPinging(resetSequence: false)
    }
    
    func resume() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            do {
                try self.pinger?.startPinging()
            } catch {
                print("Failed to resume pinging: \(error.localizedDescription)")
            }
        }
    }
}
