//
//  TestResultDataService.swift
//  PingStats
//
//  Created by Elvis Dorow on 13/11/24.
//

import Foundation
import CoreData

class TestResultDataService: DataService {
    
    private let entityName = "TestResult"
    @Published var testResults: [TestResult] = []
    
    override init() {
        super.init()
    }
    
    private func load() {
        let request = NSFetchRequest<TestResult>(entityName: entityName)
        do {
            testResults = try container.viewContext.fetch(request)
        } catch let error {
            print("Error loading target hosts \(error)")
        }
    }
    
    func addTestResult() {
        
    }
    
}
