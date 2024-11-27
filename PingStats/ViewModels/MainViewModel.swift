//
//  MainViewModel.swift
//  PingStats
//
//  Created by Elvis Dorow on 25/07/24.
//

import Foundation
import Combine
import SwiftUI
import Network

class MainViewModel: ObservableObject {
    
    var settings: Settings = .shared
    
    @Published var isAnalysisRunning = false
    @Published var statusMessage = "No data"
    @Published var hasNetworkError = false

    @Published var elapsedTime: TimeInterval = 0
    
    var timer: AnyCancellable?
    
    @Published var isConnected: Bool = false
    @Published var connectionType: ConnectionType = .unknown

    @Published var chartType: SegmentedControl.SelectedControl = .barChart
    @Published var chartItems: [ChartItem] = []
    private let numBarsInChart = 40
    
    @Published var pingStat: PingStat = .init()
    @Published var pingLogs: [PingLog] = []

    var pingService = PingService.instance
    var cancellables: Set<AnyCancellable> = []
    
    var sessionDataService = SessionDataService.instance
    
    var session: Session?
    
    init() {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
                self.updateConnectionType(path)
            }
        }
        monitor.start(queue: DispatchQueue.global())
    }
    
    
    func start() {
        self.pingStat = PingStat()
        
        let sessionParams = SessionParam(settings: .shared)
        session = Session(sessionParams)
        
        resetChart()

        addSubscriptions()
        pingService.start()
        
        isAnalysisRunning = true
        elapsedTime = 0
        
        hasNetworkError = false
        statusMessage = "Pinging \(sessionParams.host)..."
        
        if !sessionParams.hostname.isEmpty {
            statusMessage = "Pinging \(sessionParams.host) (\(sessionParams.hostname))..."
        }
    }
    
    func stop() {
        isAnalysisRunning = false
        statusMessage = "Test finished"
        hasNetworkError = false
        
        cancellables.forEach { $0.cancel() }
        
        timer?.cancel()
        timer = nil
        
        pingService.stop()
                
        let endDate = Date()
        
        if let session = session {
            session.connectionType = connectionType.rawValue
            session.endDate = endDate
            session.elapsedTime = endDate.timeIntervalSince(session.startDate)
            
            sessionDataService.add(session: session)
        }
    }
    
    private func addSubscriptions() {
        pingService.$response
            .receive(on: DispatchQueue.main)
            .sink { [weak self] response in
                guard
                    let self = self,
                    let response = response,
                    let session = session else { return }

                let pingLog = session.addResponse(response)                
                self.pingLogs.append(pingLog)
                self.pingStat = session.getPingStat()
                self.hasNetworkError = false
                
                if response.error != nil {
                    self.hasNetworkError = true
                }
                
                updateChart()
        }
        .store(in: &cancellables)
        
        timer = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink {[weak self] _ in
                if let self = self, let session = self.session {
                    self.elapsedTime = Date().timeIntervalSince(session.startDate)
                    if self.elapsedTime >= TimeInterval(session.parameters.maxtimeSetting.rawValue) {
                        self.stop()
                    }
                }
            }
    }
    
    private func updateChart() {
        if let session = self.session {
            let lastResponses = Array(session.responses.suffix(numBarsInChart))
            for index in 0..<lastResponses.count {
                if lastResponses[index].error != nil {
                    chartItems[index].duration = 0.0
                    chartItems[index].error = true
                } else {
                    chartItems[index].duration = lastResponses[index].duration
                }
            }
        }
    }
    
    private func resetChart() {
        pingLogs = []
        chartItems = []
        for idx in 1...numBarsInChart {
            chartItems.append(.init(sequence: idx, error: false, duration: 0.0))
        }
    }

    private func updateConnectionType(_ path: NWPath) {
        if path.usesInterfaceType(.wifi) {
            self.connectionType = .wifi
        } else if path.usesInterfaceType(.cellular) {
            self.connectionType = .cellular
        } else if path.usesInterfaceType(.wiredEthernet) {
            self.connectionType = .ethernet
        } else {
            self.connectionType = .unknown
        }
    }
}

enum ConnectionType: String {
    case wifi
    case cellular
    case ethernet
    case unknown
    
    func toString() -> String {
        switch self {
        case .wifi:
            return "Wi-Fi"
        case .cellular:
            return "Cellular"
        case .ethernet:
            return "Ethernet"
        case .unknown:
            return "Unknown"
        }
    }
}
