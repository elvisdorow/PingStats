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
    @Published var hosts: [Host] = []
    
    override init() {
        super.init()
        self.load()
    }
    
    func load() {
        hosts = []
        let request = NSFetchRequest<TargetHost>(entityName: entityName)
        do {
            let targetHosts = try container.viewContext.fetch(request)
            
            for targetHost in targetHosts {
                let host = Host()
                host.host = targetHost.host ?? ""
                host.type = HostType(rawValue: targetHost.type ?? "ip") ?? .ip
                hosts.append(host)
            }
            
        } catch let error {
            print("Error loading target hosts \(error)")
        }
    }
    
    func add(host: Host) {
        let targetHost = TargetHost(context: container.viewContext)
        targetHost.type = host.type.rawValue
        targetHost.host = host.host        
        save()
    }
    
    func get(host: String, type: HostType) -> TargetHost? {
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
        save()
    }
}
