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
        
        return host
    }
    
    func delete(host: Host) {
        if let targetHost = dataService.get(host: host.host, type: host.type) {
            dataService.delete(targetHost: targetHost)
        }
    }
    
    func reload() {
        dataService.load()
    }
}
