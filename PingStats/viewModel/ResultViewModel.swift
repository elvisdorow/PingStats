//
//  ResultViewModel.swift
//  PingStats
//
//  Created by Elvis Dorow on 11/09/24.
//

import Foundation
import RealmSwift

class ResultViewModel: ObservableObject {
 
    private var realm: Realm
    
    @Published var results: Results<MeasurementResult>
    
    init() {
        realm = try! Realm()
        results = realm.objects(MeasurementResult.self)
    }
    
    func refresh() {
        results = realm.objects(MeasurementResult.self)
    }
    
    func deleteResult(at offsets: IndexSet) {
        offsets.forEach { index in
            let result = results[index]
            
            guard !result.isInvalidated else {
                print("Result already invalidated")
                return
            }
            
            do {
                try realm.write {
                    realm.delete(result)
                }
            } catch {
                print("Error deleting task: \(error.localizedDescription)")
            }
        }
        
        refresh()
    }

    
}
