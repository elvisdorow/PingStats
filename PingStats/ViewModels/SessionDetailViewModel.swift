//
//  SessionDetailViewModel.swift
//  PingStats
//
//  Created by Elvis Dorow on 27/12/24.
//

import SwiftUI

class SessionDetailViewModel: ObservableObject {
    
    let session: Sessions
    
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
            let formatedDate = FileService.instance.formatDateToString(session.startDate!, format: "yyyy-MM-ddHHmmss")
            let filename = "log_\(formatedDate).txt"
            
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsDirectory.appendingPathComponent(filename)
            try text.write(to: fileURL, atomically: true, encoding: .utf8)
            
            let av = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
            UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
        } catch {
            print("Error sharing session: \(error)")
        }
    }
}
