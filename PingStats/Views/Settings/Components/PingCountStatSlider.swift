//
//  PingCountStats.swift
//  PingStats
//
//  Created by Elvis Dorow on 27/09/24.
//

import SwiftUI

struct PingCountStatSlider: View {

    @Binding var countStat: PingCountStat

    var body: some View {
        HStack {
            Slider(value: Binding( 
                get: {
                    Double(self.countStat.toSliderValue())
                },
                set: { newValue in
                    self.countStat = PingCountStat.fromSliderValue(val: newValue)
                }
            ), in: 1...7, step: 1)

            Text("\(countStat.toString())")
        }
    }
}

enum PingCountStat: Int {
    case count30 = 30
    case count50 = 50
    case count100 = 100
    case count300 = 300
    case count500 = 500
    case count1000 = 1000
    case countAll  = 0

    static func fromSliderValue(val: Double) -> PingCountStat {
        switch val {
            case 1.0:   return .count30
            case 2.0:   return .count50
            case 3.0:   return .count100
            case 4.0:   return .count300
            case 5.0:   return .count500
            case 6.0:   return .count1000
            case 7.0:   return .countAll
            default:    return .count30
        }
    }

    func toSliderValue() -> Double {
        switch self {
            case .count30:   return 1.0
            case .count50:   return 2.0
            case .count100:  return 3.0
            case .count300:  return 4.0
            case .count500:  return 5.0
            case .count1000: return 6.0
            case .countAll:  return 7.0
        }
    }

    func toString() -> String {
        switch self {
            case .count30:   return "30"
            case .count50:   return "50"
            case .count100:  return "100"
            case .count300:  return "300"
            case .count500:  return "500"
            case .count1000: return "1000"
            case .countAll:  return "All"
        }
    }
}
 

#Preview {
    PingCountStatSlider(countStat: .constant(.count30)).padding()
}
