//
//  FileService.swift
//  PingStats
//
//  Created by Elvis Dorow on 27/12/24.
//

import Foundation
import SwiftUI

class FileService {
    
    static let instance = FileService()
    
    private init() {}
    
    // Save Session to a file
    func saveSession(session: Sessions) throws {
        print("saving session to a file ")
        
        let sessionFile = createSessionFile(session: session)
        let text = sesstionToText(sessionTextFile: sessionFile)
        let formatedDate = formatDateToString(session.startDate!, format: "yyyy-MM-dd-HHmmss")
        let filename = "log_\(formatedDate).txt"
        
        do {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsDirectory.appendingPathComponent(filename)
            try text.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            print("Error saving session \(error)")
            throw error
        }
    }
    
    func createSessionFile(session: Sessions) -> SessionTextFile {
        var pingLogs: [PingLogTextFile] = []
        
        if let logs = session.logs {
            for log in logs {
                if let log = log as? SessionLog {
                    pingLogs.append(
                        PingLogTextFile(
                            dateTime: (log as AnyObject).dateTime!,
                            sequence: Int((log as AnyObject).sequence),
                            bytes: Int((log as AnyObject).bytes),
                            timeToLive: Int((log as AnyObject).timeToLive),
                            duration: (log as AnyObject).duration,
                            error: (log as AnyObject).error))
                }
            }
        }
        
        let sessionFile: SessionTextFile =
            .init(
                startDate: session.startDate!,
                endDate: session.endDate!,
                host: session.host!,
                resolvedIpOrHost: session.resolvedIpOrHost!,
                connectionType: session.connectionType!,
                bestPing: session.bestPing,
                worstPing: session.worstPing,
                jitter: session.jitter,
                averagePing: session.averagePing,
                packageLoss: session.packageLoss,
                pingCount: session.pingCount,
                elapsedTime: session.elapsedTime,
                pingTimeout: PingTimeout(rawValue: Int(session.pingTimeout))?.toString() ?? "",
                pingInterval: PingInterval(rawValue: Int(session.pingInterval))?.toString() ?? "",
                maxtimeSetting: PingMaxtime(rawValue: Int(session.maxtimeSetting))?.toString() ?? "",
                logs: pingLogs
            )

        return sessionFile
    }
    
    func sesstionToText(sessionTextFile: SessionTextFile) -> String {
        var text = """

        Started: \(formatDateToString(sessionTextFile.startDate, format: "yyyy-MM-dd HH:mm:ss"))
        Host: \(sessionTextFile.host)
        Resolved IP or Host: \(sessionTextFile.resolvedIpOrHost)
        Connection Type: \(sessionTextFile.connectionType)

        Best Ping: \(sessionTextFile.bestPing.pingDurationFormat()) ms
        Worst Ping: \(sessionTextFile.worstPing.pingDurationFormat()) ms
        Jitter: \(sessionTextFile.jitter.pingDurationFormat()) ms

        Average: \(sessionTextFile.averagePing.pingDurationFormat()) ms
        Package Loss: \(sessionTextFile.packageLoss) %

        Ping Count: \(sessionTextFile.pingCount)
        Elapsed Time: \(Formatter.elapsedTime(sessionTextFile.elapsedTime))

        Ping Timeout: \(sessionTextFile.pingTimeout)
        Ping Interval: \(sessionTextFile.pingInterval)
        Max timeout: \(sessionTextFile.maxtimeSetting)
        
        -----------------\n\n
        """
        
        for log in sessionTextFile.logs {
            text.append(pingLogToText(pingLog: log))
            text.append("\n")
        }
        
        return text
    }
    
    private func pingLogToText(pingLog: PingLogTextFile) -> String {
        if let error = pingLog.error {
            return "\(error)"
        } else {
            let text = "\(pingLog.bytes) bytes: seq=\(pingLog.sequence) ttl=\(pingLog.timeToLive) time=\(Int(pingLog.duration)) ms"
            return text
        }
    }
    
    
    func formatDateToString(_ date: Date, format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
}
