//
//  MaxTimeSlider.swift
//  PingStats
//
//  Created by Elvis Dorow on 25/09/24.
//

import SwiftUI

struct PingMaxtimeSlider: View {
    
    @Binding var maxtime: PingMaxtime
    
    var body: some View {
        HStack {
            Image(systemName: "timer").opacity(0.6)
            Slider(value: Binding(
                get: {
                    self.maxtime.toSliderValue()
                },
                set: { newValue in
                    self.maxtime = PingMaxtime.fromSliderValue(val: newValue)
                }
            ), in: 1...9, step: 1)
            Text("\(maxtime.toString())")
                .frame(width: 65)
        }
    }
}

enum PingMaxtime: Int {
    case min1 = 60 // 1 min
    case min2 = 120 // 2 min
    case min5 = 300 // 5 min
    case min10 = 600 // 10 min
    case min15 = 900 // 15 min
    case min30 = 1800 // 30 min
    case hour1 = 3600 // 1 hour
    case hour2 = 7200 // 2 hour
    case infinity = 9999999

    static func fromSliderValue(val: Double) -> PingMaxtime {
        switch val {
            case 1.0:   return .min1
            case 2.0:   return .min2
            case 3.0:   return .min5
            case 4.0:   return .min10
            case 5.0:   return .min15
            case 6.0:   return .min30
            case 7.0:   return .hour1
            case 8.0:   return .hour2
            case 9.0:   return .infinity
            default:    return .min1
        }
    }

    func toSliderValue() -> Double {
        switch self {
            case .min1:   return 1.0
            case .min2:   return 2.0
            case .min5:   return 3.0
            case .min10:   return 4.0
            case .min15:   return 5.0
            case .min30:   return 6.0
            case .hour1:   return 7.0
            case .hour2:   return 8.0
            case .infinity:   return 9.0
        }
    }

    func toString() -> String {
        switch self {
            case .min1:   return "1 min"
            case .min2:   return "2 min"
            case .min5:   return "5 min"
            case .min10:   return "10 min"
            case .min15:   return "15 min"
            case .min30:   return "30 min"
            case .hour1:   return "1 hour"
            case .hour2:   return "2 hour"
            case .infinity:   return " ∞ "
        }
    }
}

#Preview {
    PingMaxtimeSlider(maxtime: .constant(.min1)).padding()
}
