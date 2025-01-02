//
//  SessionDetailViewModel.swift
//  PingStats
//
//  Created by Elvis Dorow on 27/12/24.
//

import SwiftUI

class SessionDetailViewModel: ObservableObject {
    
    let session: Sessions
    
    var fileURL: URL?
    
    init(session: Sessions) {
        self.session = session
    }
    
    func saveSessionToFile() {
        do {
            try FileService.instance.saveSession(session: session)
        } catch {
            print("Error saving session to file: \(error)")
        }
    }
    
    func shareSession() {
        do {
            let sessionFile = FileService.instance.createSessionFile(session: session)
            let text = FileService.instance.sesstionToText(sessionTextFile: sessionFile)
            let formatedDate = FileService.instance.formatDateToString(session.startDate!, format: "yyyy-MM-dd-HHmmss")
            let filename = "log_\(formatedDate).txt"
            
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            fileURL = documentsDirectory.appendingPathComponent(filename)

            if let fileURL = fileURL {
                try text.write(to: fileURL, atomically: true, encoding: .utf8)
            }
        } catch {
            print("Error sharing session: \(error)")
        }
    }
}
