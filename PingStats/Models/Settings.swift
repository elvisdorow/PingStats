import SwiftUI

class Settings: ObservableObject {
    
    static let shared = Settings()
    private init() { }

    @AppStorage("theme") var theme: Theme = .device {
        didSet {
            appearance = theme.rawValue
        }
    }
    
    @AppStorage("pingInterval") var pingInterval: PingInterval = .sec1
    @AppStorage("pingCountStat") var pingCountStat: PingCountStat = .count30
    @AppStorage("pingMaxtime") var maxtimeSetting: PingMaxtime = .min5
    @AppStorage("pingTimeout") var pingTimeout: PingTimeout = .sec1 
    @AppStorage("host") var host: String = "1.1.1.1"
    @AppStorage("hostname") var hostname: String = "one.one.one.one"
    
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
    
    var icon: Image {
        switch self  {
        case .device: return Image(systemName: "circle.lefthalf.filled")
        case .light: return Image(systemName: "sun.max")
        case .dark: return Image(systemName: "moon")
        }
    }
}