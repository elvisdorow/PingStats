//
//  NetworkMonitor.swift
//  PingStats
//
//  Created by Elvis Dorow on 05/09/24.
//

import Foundation
import Network

class NetworkMonitor: ObservableObject {
    private var monitor: NWPathMonitor
    private var queue = DispatchQueue.global(qos: .background)
    
    @Published var isConnected: Bool = false
    @Published var connectionType: ConnectionType = .unknown

    enum ConnectionType {
        case wifi
        case cellular
        case ethernet
        case unknown
    }
    
    init() {
        monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
                self.updateConnectionType(path)
            }
        }
        monitor.start(queue: queue)
    }
    
    private func updateConnectionType(_ path: NWPath) {
        if path.usesInterfaceType(.wifi) {
            connectionType = .wifi
        } else if path.usesInterfaceType(.cellular) {
            connectionType = .cellular
        } else if path.usesInterfaceType(.wiredEthernet) {
            connectionType = .ethernet
        } else {
            connectionType = .unknown
        }
    }
}

/**
 
 struct ContentView: View {
     @StateObject private var networkMonitor = NetworkMonitor()
     
     var body: some View {
         VStack {
             if networkMonitor.isConnected {
                 Text("Connected to \(networkMonitor.connectionType == .wifi ? "Wi-Fi" : networkMonitor.connectionType == .cellular ? "Cellular" : "Unknown")")
             } else {
                 Text("Not Connected")
             }
         }
         .padding()
     }
 }

 */
