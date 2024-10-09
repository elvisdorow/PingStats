import SwiftUI

class Settings: ObservableObject {
    
    static let shared = Settings()
    
    @AppStorage("theme") var theme: Theme = .device {
        didSet {
            appearance = theme.rawValue
        }
    }
    
    @AppStorage("pingInterval") var pingInterval: PingInterval = .sec1
    @AppStorage("pingCountStat") var pingCountStat: PingCountStat = .count30
    @AppStorage("pingMaxtime") var maxtimeSetting: PingMaxtime = .min5
    @AppStorage("pingTimeout") var pingTimeout: PingTimeout = .sec1 
    @AppStorage("selectedIpAddress") var selectedIpAddress: String = "1.1.1.1"
    
    @AppStorage("ipAddressesData") var ipAddressesData: Data = Data()
 
    private init() {
        
    }
    
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
    
    var window: UIWindow? {
        guard let scene = UIApplication.shared.connectedScenes.first,
              let windowSceneDelegate = scene.delegate as? UIWindowSceneDelegate,
              let window = windowSceneDelegate.window else {
            return nil
        }
        return window
    }
    
    @Published var appearance: Int = 0 {
        didSet {
            print("apperance set to \(appearance)")
            switch appearance {
            case 1:
                window?.overrideUserInterfaceStyle = .light
            case 2:
                window?.overrideUserInterfaceStyle = .dark
            default:
                window?.overrideUserInterfaceStyle = .unspecified
            }
        }
    }

}

enum Theme: Int, CaseIterable, Identifiable {
    case device = 0
    case light = 1
    case dark = 2
    var id: Int { self.rawValue }

    var name: String {
        switch self {
        case .device: return String("Device")
        case .light: return String("Light")
        case .dark: return String("Dark")
        }
    }
}
