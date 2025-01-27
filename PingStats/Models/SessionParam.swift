//
//  SessionParameters.swift
//  PingStats
//
//  Created by Elvis Dorow on 15/11/24.
//

import Foundation

class SessionParam {
    
    let pingInterval: PingInterval
    let pingCountStat: PingCountStat
    let maxtimeSetting: PingMaxtime
    let pingTimeout: PingTimeout
    let pingPayload: PingPayload

    let hostType: HostType
    let host: String
    
    init(settings: Settings) {
        pingInterval = settings.pingInterval
        pingCountStat = settings.pingCountStat
        maxtimeSetting = settings.maxtimeSetting
        pingTimeout = settings.pingTimeout
        pingPayload = settings.pingPayload
        host = settings.host
        hostType = HostType(rawValue: settings.hostType) ?? .name
    }
    
}
