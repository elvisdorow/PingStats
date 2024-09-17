//
//  GaugeItem.swift
//  PingStats
//
//  Created by Elvis Dorow on 10/09/24.
//

import SwiftUI

struct GaugeItem: View {
    var body: some View {
        HStack(spacing: 20) {
            
            Gauge(value: 0.34, in: 0...1) {
                
                Text("Excelent")
                    .font(.title)
                    .padding(.top, 30)
            } currentValueLabel: {
                Label("Gaming", systemImage: "gamecontroller.fill")
            }
            .gaugeStyle(.accessoryCircular)
            .frame(maxWidth: .infinity, maxHeight: .infinity)

        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    GaugeItem()
}
