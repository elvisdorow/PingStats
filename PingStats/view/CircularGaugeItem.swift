//
//  GaugeTestView.swift
//  PingStats
//
//  Created by Elvis Dorow on 23/07/24.
//

import SwiftUI

/*
struct GaugeTestView: View {
    
    @State var gamingValue: Double = 0.34
    @State var gamingStatus: String = "Good"
    
    var body: some View {
        CircularGaugeItem(
            type: "Video Call",
            icon: "gamecontroller.fill", 
            value: $gamingValue, 
            status: $gamingStatus)
    }
}
 */

struct CircularGaugeItem: View {
    let type: String
    let icon: String
    
    @Binding var value: Double
    @Binding var status: MeasurementModel.Status

    var body: some View {
        VStack {
            Gauge(
                value: value,
                label: {
                    Text("\(type)")
                },
                currentValueLabel: {
                    Image(systemName: "\(icon)")
                        .foregroundColor(Color("IconColor"))
                },
                minimumValueLabel: {
                    Text("")
                },
                maximumValueLabel: {
                    Text("\(status.rawValue)")
                }
                
            ).gaugeStyle(SpeedometerGaugeStyle())
                .tint(Color.accent)
                .frame(maxWidth: .infinity)
        }
    }
}


struct SpeedometerGaugeStyle: GaugeStyle {

    func makeBody(configuration: Configuration) -> some View {
        VStack(spacing:0) {
            ZStack {
                Circle()
                    .trim(from: 0, to: 0.75 * configuration.value)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [.accent, .accent.opacity(0.75)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing),
                            style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .rotationEffect(.degrees(135))
                    .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/)

                Circle()
                    .trim(from: 0, to: 0.75)
                    .stroke(.accent,
                            style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .rotationEffect(.degrees(135))
                    .opacity(0.3)

                
                VStack(spacing: 5) {
                    configuration.currentValueLabel
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.primary.opacity(0.8))
                    configuration.label.font(.caption2)
                    
                }

            }
            configuration.maximumValueLabel.font(.system(size: 13))
                .offset(y: -8)

        }
    }

}

/*
 #Preview {
 GaugeTestView()
 }
 */
