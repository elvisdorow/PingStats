//
//  PingTimeoutSlider.swift
//  PingStats
//
//  Created by Elvis Dorow on 25/09/24.
//

import SwiftUI

struct PingTimeoutSlider: View {
    
    @Binding var pingTimeout: PingTimeout
    
    var body: some View {
        HStack {
            Slider(value: Binding(
                get: {
                    self.pingTimeout.toSliderValue()
                },
                set: { newValue in
                    self.pingTimeout = PingTimeout.fromSliderValue(val: newValue)
                }
            ), in: 1...10, step: 1)
            Text("\(pingTimeout.toString())")
                .frame(width: 65)

        }
    }

}

enum PingTimeout: Int {
    case sec1 = 1
    case sec2 = 2
    case sec3 = 3
    case sec4 = 4
    case sec5 = 5
    case sec6 = 6
    case sec7 = 7
    case sec8 = 8
    case sec9 = 9
    case sec10 = 10

    static func fromSliderValue(val: Double) -> PingTimeout {
        switch val {
            case 1.0:   return .sec1
            case 2.0:   return .sec2
            case 3.0:   return .sec3
            case 4.0:   return .sec4
            case 5.0:   return .sec5
            case 6.0:   return .sec6
            case 7.0:   return .sec7
            case 8.0:   return .sec8
            case 9.0:   return .sec9
            case 10.0:  return .sec10
            default:    return .sec1
        }
    }

    func toSliderValue() -> Double {
        switch self {
            case .sec1:   return 1.0
            case .sec2:   return 2.0
            case .sec3:   return 3.0
            case .sec4:   return 4.0
            case .sec5:   return 5.0
            case .sec6:   return 6.0
            case .sec7:   return 7.0
            case .sec8:   return 8.0
            case .sec9:   return 9.0
            case .sec10:  return 10.0
        }
    }

    func toString() -> String {
        "\(self.rawValue) sec"
    }
}

#Preview {
    PingTimeoutSlider(pingTimeout: .constant(.sec1)).padding()
}
