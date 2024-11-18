//
//  DBService.swift
//  PingStats
//
//  Created by Elvis Dorow on 13/11/24.
//

import Foundation
import CoreData

class TargetHostDataService: DataService {
    
    private let entityName = "TargetHost"
    @Published var targetHosts: [TargetHost] = []
    
    override init() {
        super.init()
        self.load()
    }
    
    private func load() {
        let request = NSFetchRequest<TargetHost>(entityName: entityName)
        do {
            targetHosts = try container.viewContext.fetch(request)
        } catch let error {
            print("Error loading target hosts \(error)")
        }
    }
    
    func add(host: String, hostname: String?) {
        let targetHost = TargetHost(context: container.viewContext)
        targetHost.host = host
        targetHost.hostname = hostname
        applyChanges()
    }
    
    func get(host: String) -> TargetHost? {
        let request = NSFetchRequest<TargetHost>(entityName: entityName)
        request.predicate = NSPredicate(format: "host == %@", host)
        
        do {
            let results = try container.viewContext.fetch(request)
            if let targetHost = results.first {
                return targetHost
            }
        } catch {
            print("Fetch failed: \(error)")
        }
        return nil
    }
    
    func delete(targetHost: TargetHost) {
        container.viewContext.delete(targetHost)
        applyChanges()
    }

    
    private func applyChanges() {
        save()
        load()
    }
    
}
