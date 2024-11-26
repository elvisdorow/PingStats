//
//  PingPayloadSlider.swift
//  PingStats
//
//  Created by Elvis Dorow on 21/11/24.
//

import SwiftUI

struct PingPayloadSlider: View {
    
    @Binding var payload: PingPayload
    
    var body: some View {
        HStack {
            Slider(value: Binding(
                get: {
                    self.payload.toSliderValue()
                },
                set: { newValue in
                    self.payload = PingPayload.fromSliderValue(val: newValue)
                }
            ), in: 1...6, step: 1)

            Text("\(payload.toString())")
                .frame(width: 90)
        }
    }
}

enum PingPayload: Int {
    case bytes16 = 16
    case bytes32 = 32
    case bytes64 = 64
    case bytes128 = 128
    case bytes256 = 256
    case bytes512 = 512

    static func fromSliderValue(val: Double) -> PingPayload {
        switch val {
        case 1.0:   return .bytes16
        case 2.0:   return .bytes32
        case 3.0:   return .bytes64
        case 4.0:   return .bytes128
        case 5.0:   return .bytes256
        case 6.0:   return .bytes512
        default:    return .bytes32
        }
    }

    func toSliderValue() -> Double {
        switch self {
        case .bytes16:   return 1.0
        case .bytes32:   return 2.0
        case .bytes64:   return 3.0
        case .bytes128:   return 4.0
        case .bytes256:   return 5.0
        case .bytes512:   return 6.0
        }
    }

    func toString() -> String {
        switch self {
        case .bytes16:   return "16 bytes"
        case .bytes32:   return "32 bytes"
        case .bytes64:   return "64 bytes"
        case .bytes128:   return "128 bytes"
        case .bytes256:   return "256 bytes"
        case .bytes512:   return "512 bytes"
        }
    }
}

#Preview {
    PingPayloadSlider(payload: .constant(.bytes256)).padding()
}
