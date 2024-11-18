//
//  DataService.swift
//  PingStats
//
//  Created by Elvis Dorow on 13/11/24.
//

import Foundation
import CoreData

class DataService {
    let container: NSPersistentContainer
    let containerName: String = "PingStatsContainer"
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { (_, error) in
            if let error = error {
                print("Error loading database: (\(error.localizedDescription)")
            }
        }
    }
    
    func save() {
        do {
            try container.viewContext.save()
        } catch {
            print("Error saving data: \(error)")
        }
    }


}
