import SwiftUI

class Settings: ObservableObject {
    
    static let shared = Settings()
    
    @AppStorage("theme") var theme: Theme = .system
    
    @AppStorage("pingInterval") var pingInterval: PingInterval = .sec1
    @AppStorage("pingCountStat") var pingCountStat: PingCountStat = .count30
    @AppStorage("pingMaxtime") var maxtimeSetting: PingMaxtime = .min5
    @AppStorage("pingTimeout") var pingTimeout: PingTimeout = .sec1 
    @AppStorage("selectedIpAddress") var selectedIpAddress: String = "1.1.1.1"
    
    @AppStorage("ipAddressesData") var ipAddressesData: Data = Data()
 
    private init() {}
    
    var ipAddresses: [String] {
        get {
            // Deserialize the Data back to an array of Strings
            if let savedArray = try? JSONDecoder().decode([String].self, from: ipAddressesData) {
                return savedArray
            }
            return [
                "1.1.1.1",
                "8.8.8.8",
                "8.8.4.4"
            ]
        }
        set {
            // Serialize the array to Data
            if let encoded = try? JSONEncoder().encode(newValue) {
                ipAddressesData = encoded
            }
        }
    }

}
