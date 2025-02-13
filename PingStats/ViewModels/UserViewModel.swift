//
//  UserViewModel.swift
//  PingStats
//
//  Created by Elvis Dorow on 08/02/25.
//

import Foundation
import RevenueCat

@MainActor
class UserViewModel: ObservableObject {

    @Published var isPayingUser: Bool = false
        
    init() {
        checkUserSubscription()
        checkSubscriptionStatusChange()
     }

     func checkUserSubscription() {
         logger.info("Checking subscription")
         Purchases.shared.getCustomerInfo { (customerInfo, error) in
                 if let customerInfo = customerInfo {
                     self.isPayingUser = customerInfo.entitlements["Pro"]?.isActive == true
                     logger.debug("Is paying customer? \(self.isPayingUser)")
             }
         }
     }
    
    func checkSubscriptionStatusChange() {        
        Task {
            for try await customerInfo in Purchases.shared.customerInfoStream {
                logger.info("Status changed")
                if customerInfo.entitlements["Pro"]?.isActive == true {
                    self.isPayingUser = true
                }
            }
        }
    }    
}
