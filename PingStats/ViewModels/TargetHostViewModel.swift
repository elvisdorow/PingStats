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
    
    @Published var targetHosts: [TargetHost] = []
    var cancellables: [AnyCancellable] = []
    
    var dataService: TargetHostDataService = TargetHostDataService()
    
    init() {
        bindSubscribers()
    }
    
    private func bindSubscribers() {
        dataService.$targetHosts
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (returnedTargetHosts) in
                self?.targetHosts = returnedTargetHosts
            }
            .store(in: &cancellables)
    }
    
    func addNew(host: String) async throws {
        guard IPUtils.validateIPAddressOrHostname(host) else {
            throw IpHostError.invalid
        }
        
        guard dataService.get(host: host) == nil else {
            throw IpHostError.alreadyExists
        }
        
        let host: String = host
        var hostname: String? = nil
        
        if IPUtils.isValidIPv4(host) {
            // if address is an IP
            hostname = await IPUtils.resolveHostname(for: host)
        }
        
        dataService.add(host: host, hostname: hostname)
    }
    
    func delete(targetHost: TargetHost) {
        dataService.delete(targetHost: targetHost)
    }
}
