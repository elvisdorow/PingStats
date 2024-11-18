//
//  SessionParameters.swift
//  PingStats
//
//  Created by Elvis Dorow on 15/11/24.
//

import Foundation

struct SessionParam {
    
    let pingInterval: PingInterval
    let pingCountStat: PingCountStat
    let maxtimeSetting: PingMaxtime
    let pingTimeout: PingTimeout
    let host: String
    let hostname: String

    init(settings: Settings) {
        pingInterval = settings.pingInterval
        pingCountStat = settings.pingCountStat
        maxtimeSetting = settings.maxtimeSetting
        pingTimeout = settings.pingTimeout
        host = settings.host
        hostname = settings.hostname
    }
    
}
