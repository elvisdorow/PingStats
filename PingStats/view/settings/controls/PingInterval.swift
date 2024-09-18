//
//  PingInterval.swift
//  PingStats
//
//  Created by Elvis Dorow on 17/09/24.
//

import SwiftUI

struct PingInterval: View {
    
    @Binding var pingIntervalValue: Double

    var interval: PingIntervalEnum = .sec1
    
    var body: some View {
        HStack {
            Slider(value: $pingIntervalValue, in: 1.0...11.0, step: 1.0)
            .onChange(of: pingIntervalValue, perform: { value in
                print(value)
            })
            Text("\(interval.getDescription())")
                .frame(width: 80)
        }
    }
}

enum PingIntervalEnum: Int {
    case ms100 = 100
    case ms200 = 200
    case ms500 = 500
    case sec1 = 1000
    case sec2 = 2000
    case sec5 = 5000
    case sec10 = 10000
    case sec30 = 30000
    case min1 = 60000 // 1 min
    case min2 = 120000// 2 min
    case min5 = 360000// 5 min

    func fromSliderValue(val: Double) -> PingIntervalEnum {
        switch val {
            case 1.0:   return .ms100
            case 2.0:   return .ms200
            case 3.0:   return .ms500
            case 4.0:   return .sec1
            case 5.0:   return .sec2
            case 6.0:   return .sec5
            case 7.0:   return .sec10
            case 8.0:   return .sec30
            case 9.0:   return .min1
            case 10.0:   return .min2
            case 11.0:  return .min5
            default:    return .sec1
        }
    }
    
    func toSliderValue() -> Double {
        switch self {
            case .ms100:  return 1.0
            case .ms200:  return 2.0
            case .ms500:  return 3.0
            case .sec1:   return 4.0
            case .sec2:   return 5.0
            case .sec5:   return 6.0
            case .sec10:  return 7.0
            case .sec30:  return 8.0
            case .min1:   return 9.0
            case .min2:   return 10.0
            case .min5:   return 11.0
        }
    }
    
    func getDescription() -> String {
        switch self {
            case .ms100:  return "100 ms"
            case .ms200:  return "200 ms"
            case .ms500:  return "500 ms"
            case .sec1:   return "1 sec"
            case .sec2:   return "2 sec"
            case .sec5:   return "5 sec"
            case .sec10:  return "10 sec"
            case .sec30:  return "30 sec"
            case .min1:   return "1 min"
            case .min2:   return "2 min"
            case .min5:   return "5 min"
        }
    }
}


#Preview {
    PingInterval(pingIntervalValue: .constant(1.0)).padding()
}
