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

@MainActor
class MainViewModel: ObservableObject {
    
    var settings: Settings = .shared
    
    @AppStorage("isMessageBgPausedShown") var isMessageBgPausedShown: Bool = false
    
    @Published var isAnalysisRunning: Bool = false
    @Published var appState: AppState = .empty {
        didSet {
            isAnalysisRunning = (appState == .running || appState == .paused)
        }
    }
    
    var actionButtonTitle: LocalizedStringResource {
        switch appState {
        case .empty, .stopped:
            return "Start"
        case .running:
            return "Stop"
        case .paused:
            return "Resume"
        }
    }
    
    @Published var statusMessage: LocalizedStringResource = "No data"
    @Published var hasNetworkError = false

    @Published var elapsedTime: TimeInterval = 0
    
    var timer: AnyCancellable?
    
    @Published var isConnected: Bool = false
    @Published var connectionType: ConnectionType = .unknown

    @Published var chartType: SegmentedControl2.SegmentedOptions = .barChart
    @Published var chartItems: [ChartItem] = []
    let numBarsInChart = 40
    
    @Published var pingStat: PingStat = .init()
    @Published var pingLogs: [PingLog] = []

    var pingService = PingService.instance
    var cancellables: Set<AnyCancellable> = []
    
    var sessionDataService = SessionDataService.instance
    
    var session: Session?
    var sessionParams: SessionParam = SessionParam(settings: .shared)
    
    @Published var hostTextBox: String = ""
    
    init() {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
                self.updateConnectionType(path)
            }
        }
        monitor.start(queue: DispatchQueue.global())
        
        self.hostTextBox = settings.host
    }
        
    func start() {
        UIApplication.shared.isIdleTimerDisabled = true
        
        resetChart()
        pingStat = PingStat()
        
        addPingerSubscription()
        addTimerSubscription()
        
        sessionParams = SessionParam(settings: .shared)
        session = Session(sessionParams)
        hostTextBox = sessionParams.host

        statusMessage = "Pinging \(sessionParams.host)..."

        if sessionParams.hostType == .ip {
            IPUtils.resolveHostname(for: sessionParams.host) {[weak self] hostname in
                if let hostname = hostname, let self = self {
                    self.session?.resolvedIpOrHost = hostname
                    self.statusMessage = "Pinging \(self.sessionParams.host) (\(hostname))"
                }
            }
        }

        pingService.start(param: sessionParams)
        
        appState = .running
        elapsedTime = 0
        
        hasNetworkError = false
        
        AnalyticsService.instance.logEvent(name: "start_test", parameters: ["host": sessionParams.host])
    }
    
    func stop() {
        UIApplication.shared.isIdleTimerDisabled = false

        appState = .stopped
        if let resolvedIpOrHoust = session?.resolvedIpOrHost {
            statusMessage = "Test finished: \(session?.parameters.host ?? "") (\(resolvedIpOrHoust))"
        } else {
            statusMessage = "Test finished: \(session?.parameters.host ?? "")"
        }
            
        hasNetworkError = false
        
        cancellables.forEach { $0.cancel() }
        
        timer?.cancel()
        timer = nil
        
        pingService.stop(resetSequence: true)
                
        let endDate = Date()
        
        if let session = session {
            session.connectionType = connectionType.getKey()
            session.endDate = endDate
            session.elapsedTime = elapsedTime
            
            session.generateFullTestPingStat()
            pingStat = session.pingStat!
            
            sessionDataService.add(session: session)
        }
        
        AnalyticsService.instance.logEvent(name: "stop_test", parameters: ["host": session?.parameters.host ?? ""])
    }
    
    func pause() {
        pingService.stop(resetSequence: false)
        UIApplication.shared.isIdleTimerDisabled = false
        appState = .paused
        statusMessage = "Test paused"
        
        timer?.cancel()
        timer = nil
        
        AnalyticsService.instance.logEvent(name: "pause_test", parameters: ["host": session?.parameters.host ?? ""])
    }
    
    func resume() {
        UIApplication.shared.isIdleTimerDisabled = true
        
//        let sessionParams = SessionParam(settings: .shared)

        guard let session = self.session else { return }
        
        statusMessage = "Pinging \(session.parameters.host)..."

        if session.parameters.hostType == .ip {
            IPUtils.resolveHostname(for: session.parameters.host) {[weak self] hostname in
                if let hostname = hostname {
                    self?.session?.resolvedIpOrHost = hostname
                    self?.statusMessage = "Pinging \(session.parameters.host) (\(hostname))"
                }
            }
        }

        pingService.start(param: sessionParams)
        addTimerSubscription()
        appState = .running
        
        AnalyticsService.instance.logEvent(name: "resume_test", parameters: ["host": session.parameters.host])
     }
    
    private func addPingerSubscription() {
        pingService.$response
            .receive(on: DispatchQueue.main)
            .sink { [weak self] response in
                guard
                    let self = self,
                    let response = response,
                    let session = session else { return }

                let pingLog = session.addResponse(response)                
                self.pingLogs.append(pingLog)
                self.pingStat = session.getInstantPingStat()
                self.hasNetworkError = false
                
                if session.parameters.hostType == .name {
                    if let ipaddress = response.ipv4Address {
                        session.resolvedIpOrHost = ipaddress
                        self.statusMessage = "Pinging \(session.parameters.host) (\(ipaddress))"
                    }
                }
                
                if response.error != nil {
                    self.hasNetworkError = true
                }
                
                updateChart()
        }
        .store(in: &cancellables)
    }
    
    private func addTimerSubscription() {
        timer = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink {[weak self] _ in
                if let self = self, let session = self.session {
                    self.elapsedTime = self.elapsedTime + 1.0
                    
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
                
                if index >= chartItems.count {
                    chartItems.append(.init(sequence: index, error: false, duration: 0.0))
                }
                
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
//        for idx in 1...numBarsInChart {
//            chartItems.append(.init(sequence: idx, error: false, duration: 0.0))
//        }
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

enum AppState: String {
    case empty
    case running
    case paused
    case stopped
}

enum ConnectionType: LocalizedStringResource {
    case wifi
    case cellular
    case ethernet
    case unknown
    
    var localizedValue: LocalizedStringResource {
        switch self {
        case .wifi:
            return LocalizedStringResource("connection_type_wifi")
        case .cellular:
            return LocalizedStringResource("connection_type_cellular")
        case .ethernet:
            return LocalizedStringResource("connection_type_ethernet")
        case .unknown:
            return LocalizedStringResource("connection_type_unknown")
        }
    }
    
    func toString() -> String {
        String(localized: localizedValue)
    }
    
    func getKey() -> String {
        localizedValue.key
    }
    
    init(fromKey key: String) {
        switch key {
        case "connection_type_wifi":
            self = .wifi
        case "connection_type_cellular":
            self = .cellular
        case "connection_type_ethernet":
            self = .ethernet
        case "connection_type_unknown":
            self = .unknown
        default:
            self = .unknown
        }
    }
}
