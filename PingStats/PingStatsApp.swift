//
//  PingStatsApp.swift
//  PingStats
//
//  Created by Elvis Dorow on 15/07/24.
//

import SwiftUI
import RealmSwift

@main
struct PingStatsApp: SwiftUI.App {
    
    init() {
        configureRealm()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
    
    func configureRealm() {
        let config = Realm.Configuration(
            schemaVersion: 2, // Increment this whenever schema changes
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 2 {
                    migration.enumerateObjects(ofType: MeasurementResult.className()) { oldObject, newObject in
                        newObject!["pingInterval"] = 0
                        newObject!["maxtimeSetting"] = 0
                        newObject!["pingTimeout"] = 0
                    }
                }
            }
        )

        // Set this as the default Realm configuration
        Realm.Configuration.defaultConfiguration = config

        // Optionally open Realm here to ensure it works correctly
        do {
            let realm = try Realm()
            print("Realm configured successfully: \(realm.configuration.fileURL!)")
        } catch {
            print("Error configuring Realm: \(error)")
        }
    }
}

