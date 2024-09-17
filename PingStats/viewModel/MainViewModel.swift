//
//  MainViewModel.swift
//  PingStats
//
//  Created by Elvis Dorow on 25/07/24.
//

import Foundation
import SwiftyPing
import RealmSwift
import Combine
import SwiftUI

class MainViewModel: ObservableObject {
    @Published var stat: MeasurementModel = MeasurementModel()
    
    @Published var isAnalysisRunning = false

    @AppStorage("selectedIpAddress") var host: String = "1.1.1.1"
    
    @Published var statusMessage = "No data"

    @Published var startTime: Date = Date()
    @Published var elapsedTime: TimeInterval = 0
    @Published var chartItems: [PingChartItem] = []
    
    @Published var timer = Timer.publish(every: 1, on: .main, in: .common)
    var timerCancellable: Cancellable? = nil

    @Published var chartType: MySegmentedControl.SelectedControl = .barChart

    var logs: [LogTextModel] = []

    var hostName: String?
    var hostIP: String?
    
    private var pinger: SwiftyPing?
    private var errors: [PingError] = []
    private var counter: Int = 0
    
    private let numBarsInChart = 60
    
    init() {
        resetChart()
    }
    
    
    func start(_ settingsViewModel: SettingsViewModel) {
        
        stat.responses.removeAll()
        errors.removeAll()
        
        resetChart()
        
        stat = MeasurementModel()
        stat.hostAddress = host
        
        startTime = Date()
        stat.dateStart = startTime
        
        elapsedTime = 0
        
        timer = Timer.publish(every: 1, on: .main, in: .common)
        timerCancellable = timer.connect()
        
        var config: PingConfiguration = PingConfiguration(interval: 1.0, with: 5)
        config.payloadSize = 64
        config.timeToLive = 55
        
        host = settingsViewModel.selectedIpAddress
        
        if self.isValidIPAddress(host) {
            self.hostIP = host
            
            stat.ipAddress = host
            
            resolveHostname(for: host) { hostname in
                if let hostname = hostname {
                    self.hostName = hostname
                    
                    self.stat.hostAddress = hostname
                }
            }
        } else {
            self.hostIP = nil
            self.hostName = host
        }
        
        print(self.hostIP ?? "")
        print(self.hostName ?? "")
        
        if self.hostIP != nil && self.hostName != nil {
            self.statusMessage = "Pinging \(self.hostIP!) (\(self.hostName!))"
        } else {
            self.statusMessage = "Pinging \(self.host)"
        }
        
        do {
            let finalHostAddress = (self.hostName != nil ? self.hostName!: self.host)
            pinger = try SwiftyPing(host: finalHostAddress, configuration: config, queue: DispatchQueue.global())

        } catch {
            print(error.localizedDescription)
        }
        
        
        // Ping indefinitely
        pinger?.observer = { (response) in
            self.counter += 1
            let idx = self.counter
            
            let pingStatResponse = PingStatResponse(
                sequency: idx,
                dateTime: Date(),
                duration: response.duration,
                error: nil)
            
            // Test network error
            if self.counter == 4 {
                //                self.errors.append(PingError.requestTimeout)
            } else {
                if let error = response.error {
                    self.addError(error: error)
                } else {
                    self.addResponse(response: pingStatResponse)
                }
            }
            
        }
        try? pinger?.startPinging()
        
        pinger?.finished = { result in
            //            print(result.roundtrip)
        }
        
    }
    
    func stop() {
        stat.dateEnd = Date()
        
        var measurementResult: MeasurementResult = MeasurementResult()
        measurementResult.fromModel(model: stat)
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(measurementResult)
        }
        
        pinger?.haltPinging(resetSequence: true)
        counter = 0
        isAnalysisRunning = false
        statusMessage = "Test finished"
        
        timerCancellable?.cancel()
        timerCancellable = nil
    }
    
    private func addError(error: PingError) {
        errors.append(error)
        calculateCurrentStats()
        
        let logText: String = "error"
        let log = LogTextModel(type: .error, text: logText)
        self.logs.append(log)
    }
    
    private func addResponse(response: PingStatResponse) {
        stat.responses.append(response)
        calculateCurrentStats()
        updateChart()
        calcConnectionQuality()
        calcItemQuality()
        
        let dateTime: Date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        
        let responseTime = response.duration * 1000
        
        let logText: String = "\(dateFormatter.string(from: dateTime))\t icmp_seq=\(self.counter)\t ttl=55 \t time=\(String(format: "%.0f", responseTime)) ms"
        let log = LogTextModel(type: .good, text: logText)
        self.logs.append(log)
    }
    
    private func calculateCurrentStats() {
        print("Calculating stats...")
        isAnalysisRunning = true
        
        // Uses all responses to calculate stats
//        let roundtripTimes = stat.responses.map { $0.duration }

        // Use the last 30 responses
        let lastResponses = stat.responses.suffix(numBarsInChart)

        let lastRoudtripTimes = lastResponses.map { $0.duration }
        let allRoudtripTimes = stat.responses.map { $0.duration }
        
        if lastRoudtripTimes.count != 0, let min = allRoudtripTimes.min(), let max = allRoudtripTimes.max() {
            let count = Double(lastRoudtripTimes.count)
            let total = lastRoudtripTimes.reduce(0, +)
            let avg = total / count
            let variance = lastRoudtripTimes.reduce(0, { $0 + ($1 - avg) * ($1 - avg) })
            let stddev = sqrt(variance / count)
            
            stat.avaragePing = avg.scaled(by: 1000.0)
            //            self.count = Int(count)
            stat.jitter = stddev.scaled(by: 1000.0)
            
            stat.bestPing = min.scaled(by: 1000.0)
            stat.worstPing = max.scaled(by: 1000.0)
        }
        
        let lost = errors.count
        let lossPercentage = (Double(lost) / Double(counter) * 100)
        stat.packageLoss = lossPercentage
    }
    
    
    private func updateChart() {
        let lastResponses = Array(stat.responses.suffix(numBarsInChart))
        
        for index in 0..<lastResponses.count {
            chartItems[index].duration = lastResponses[index].duration
        }
    }
    
    private func resetChart() {
        logs = []
        chartItems = []
        for idx in 1...numBarsInChart {
            chartItems.append(.init(sequency: idx, duration: 0.0))
        }
    }
    
    private func calcConnectionQuality() {
        let pingScore = pingScore()
        let jitterScore = jitterScore()
        let packageLossScore = packageLossScore()
        
        self.stat.generalNetQuality = (pingScore + jitterScore + packageLossScore) / 3
    }
    
    private func calcItemQuality() {
        calcGamingQuality()
        calcVideoCallQuality()
        calcStreamingQuality()
    }
    
    private func calcGamingQuality() {
        self.stat.gamingScore = self.stat.generalNetQuality / 100
        var gamingStatus: MeasurementModel.Status = .empty
        
        switch self.stat.generalNetQuality {
        case 0..<20:
            gamingStatus = .veryBad
        case 20..<70:
            gamingStatus = .bad
        case 70..<85:
            gamingStatus = .normal
        case 85..<95:
            gamingStatus = .good
        default:
            gamingStatus = .excelent
        }
        
        self.stat.gamingStatus = gamingStatus
    }
    
    private func calcVideoCallQuality() {
        self.stat.videoCallScore = self.stat.generalNetQuality / 100

        var videoCallStatus: MeasurementModel.Status = .empty
        
        switch self.stat.generalNetQuality {
        case 0..<53:
            videoCallStatus = .veryBad
        case 53..<65:
            videoCallStatus = .bad
        case 65..<77:
            videoCallStatus = .normal
        case 77..<87:
            videoCallStatus = .good
        default:
            videoCallStatus = .excelent
        }
        
        self.stat.videoCallStatus = videoCallStatus
    }
    
    private func calcStreamingQuality() {
        self.stat.streamingScore = self.stat.generalNetQuality / 100
        
        var streamingStatus: MeasurementModel.Status = .empty
        
        switch self.stat.generalNetQuality {
        case 0..<44:
            streamingStatus = .bad
        case 58..<75:
            streamingStatus = .normal
        case 75..<83:
            streamingStatus = .good
        default:
            streamingStatus = .excelent
        }
        
        if streamingStatus == .bad || streamingStatus == .normal {
            if self.stat.packageLoss < 2.0 {
                streamingStatus = .good
                self.stat.streamingScore = 0.87
            }
        }
        
        if streamingStatus == .good && self.stat.packageLoss < 1.0 {
            streamingStatus = .excelent
            self.stat.streamingScore = 1.0
        }
        
        self.stat.streamingStatus = streamingStatus
    }
    
    private func pingScore() -> Double {
        var score = 0.0
        
        switch self.stat.avaragePing {
        case ..<20:
            score =  100
        case 20..<30:
            score = 90
        case 30..<50:
            score = 80
        case 50..<70:
            score = 60
        case 70..<100:
            score = 50
        case 100..<150:
            score = 30
        case 150..<200:
            score = 20
        case 200..<300:
            score = 10
        default:
            score = 2
        }

        return score
    }
    
    private func jitterScore() -> Double {
        var score = 0.0
        
        switch self.stat.jitter {
        case ..<5:
            score = 100
        case 5..<10:
            score = 90
        case 10..<15:
            score = 75
        case 15..<20:
            score = 60
        case 20..<25:
            score = 50
        case 25..<30:
            score = 40
        case 30..<40:
            score = 30
        case 40..<50:
            score = 20
        case 50..<70:
            score = 10
        default:
            score = 2
        }

        return score
    }
    
    private func packageLossScore() -> Double {
        var score = 0.0

        switch self.stat.packageLoss {
        case ..<0.1:
            score = 100
        case 0.1..<0.5:
            score = 75
        case 0.5..<1:
            score = 50
        default:
            score = 10
        }

        return score
    }
    
    private func resolveHostname(for ipAddress: String, completion: @escaping (String?) -> Void) {
        var hints = addrinfo(
            ai_flags: AI_NUMERICHOST,
            ai_family: AF_UNSPEC,
            ai_socktype: SOCK_STREAM,
            ai_protocol: IPPROTO_TCP,
            ai_addrlen: 0,
            ai_canonname: nil,
            ai_addr: nil,
            ai_next: nil
        )
        
        var res: UnsafeMutablePointer<addrinfo>?
        
        let status = getaddrinfo(ipAddress, nil, &hints, &res)
        
        if status == 0, let result = res {
            defer { freeaddrinfo(result) }
            
            var hostnameBuffer = [CChar](repeating: 0, count: Int(NI_MAXHOST))
            
            let getnameinfoStatus = getnameinfo(
                result.pointee.ai_addr,
                socklen_t(result.pointee.ai_addrlen),
                &hostnameBuffer,
                socklen_t(hostnameBuffer.count),
                nil,
                0,
                NI_NAMEREQD
            )
            
            if getnameinfoStatus == 0 {
                let hostname = String(cString: hostnameBuffer)
                completion(hostname)
                return
            }
        }
        completion(nil)
    }
    
    func isValidIPAddress(_ ipAddress: String) -> Bool {
        let ipv4Pattern = "^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"

        func isMatch(for pattern: String, in text: String) -> Bool {
            let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let matches = regex?.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))
            return matches?.count ?? 0 > 0
        }

        if isMatch(for: ipv4Pattern, in: ipAddress) {
            return true
        }
        return false
    }
}
