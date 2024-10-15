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
    
    let iconSize = UIScreen.main.bounds.height * 0.02

    
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
                        .frame(height: iconSize)
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
        .frame(maxWidth: UIScreen.main.bounds.width * 0.25) 
    }
}


struct SpeedometerGaugeStyle: GaugeStyle {

    let lineWith = UIScreen.main.bounds.height * 0.012
    
    func makeBody(configuration: Configuration) -> some View {
        VStack(spacing:0) {
            ZStack {
                Circle()
                    .trim(from: 0.038, to: 0.72 * configuration.value)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [.accent.opacity(0.8), .accent]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing),
                        style: StrokeStyle(lineWidth: lineWith, lineCap: .round, lineJoin: .round))
                
                    .rotationEffect(.degrees(134))
                    .animation(.easeIn, value: configuration.value)
                Circle()
                    .trim(from: 0.038, to: 0.72)
                    .stroke(.gray.gradient,
                            style: StrokeStyle(lineWidth: lineWith, lineCap: .round, lineJoin: .round))


                    .rotationEffect(.degrees(134))
                    .opacity(0.3)

                
                VStack(spacing: 5) {
                    configuration.currentValueLabel
                        .font(.system(size: 23, weight: .bold, design: .rounded))
                        .foregroundColor(.primary.opacity(0.8))
                    configuration.label.font(.caption2)
                    
                }

            }
            configuration.maximumValueLabel.font(.system(size: 13))
                .offset(y: -8)

        }
    }

}

struct CircularGaugePreview: PreviewProvider {
    @State static var status: MeasurementModel.Status = .excelent
    @State static var value = 0.97
    
    static var previews: some View {
        CircularGaugeItem(type: "Gaming", icon: "gamecontroller.fill", value: $value, status: $status)
            .frame(height: 120)
    }
}
