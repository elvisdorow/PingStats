//
//  IPAddressesViewModel.swift
//  PingStats
//
//  Created by Elvis Dorow on 30/09/24.
//

import Foundation
import Combine
import SwiftUI

enum IpHostError: Error {
    case invalid
    case alreadyExists
    
    var localizedDescription: String {
        switch self {
            case .invalid: return "Invalid Host or IP Address"
            case .alreadyExists: return "Host or IP Address Already Exists"
        }
    }
}

class TargetHostViewModel: ObservableObject {
    
    @Published var hosts: [Host] = []
    var cancellables: [AnyCancellable] = []
    
    var dataService: TargetHostDataService = TargetHostDataService()
    
    @AppStorage("goodTestsCount") var goodTestsCount: Int = 0
    @AppStorage("lastReviewedVersion") var lastReviewedVersion: String = "1.0"
    @Published var shouldShowReview = false
    var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }
    
    init() {
        bindSubscribers()
    }
    
    private func bindSubscribers() {
        dataService.$hosts
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (returnedTargetHosts) in
                self?.hosts = returnedTargetHosts
            }
            .store(in: &cancellables)
    }
    
    func addNew(ipOrHost: String) async throws -> Host{
        
        guard IPUtils.validateIPAddressOrHostname(ipOrHost) else {
            throw IpHostError.invalid
        }
        
        let type: HostType = IPUtils.isValidIPv4(ipOrHost) ? .ip : .name
        
        guard dataService.get(host: ipOrHost, type: type) == nil else {
            throw IpHostError.alreadyExists
        }
        
        let host: Host = Host()
        host.host = ipOrHost
        host.type = type
        
        dataService.add(host: host)
        
        AnalyticsService.instance.logEvent(name: "add_target_host", parameters: ["host": ipOrHost])
        checkRequestReview()
        
        return host
    }
    
    func delete(host: Host) {
        if let targetHost = dataService.get(host: host.host, type: host.type) {
            dataService.delete(targetHost: targetHost)
            
            AnalyticsService.instance.logEvent(name: "delete_target_host", parameters: ["host": host.host])
        }
    }
    
    func reload() {
        dataService.load()
    }
    
    func checkRequestReview() {
        if goodTestsCount >= 4 && lastReviewedVersion != appVersion {
            DispatchQueue.main.async {
                self.lastReviewedVersion = self.appVersion
                self.goodTestsCount = 0
                self.shouldShowReview = true
            }
            
            AnalyticsService.instance.logEvent(name: "review_request_thost")
        }
    }
}
