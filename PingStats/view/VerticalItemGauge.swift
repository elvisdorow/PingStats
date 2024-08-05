//
//  VerticalItemGauge.swift
//  PingStats
//
//  Created by Elvis Dorow on 22/07/24.
//

import SwiftUI

struct VerticalItemGauge: View {
    
    @State var gamingValue: Double = 0.0
    
    var body: some View {
        HStack {
            VerticalItemGaugeView(
                status:"Good", type: "Gamming", icon: "gamecontroller.fill", value: $gamingValue
            )
            
            /*
            Gauge(value: 30, in: 0...100) {
            } currentValueLabel: {
                Label(title: {Text("teste")}, icon: {
                    Image(systemName: "play.tv.fill").foregroundColor(.accent)
                }).font(.caption)
            } minimumValueLabel: {
            } maximumValueLabel: {
            }
            .gaugeStyle(.accessoryCircular)
            .frame(height: 300)
            .frame(width: 300)
            .tint(Gradient(colors: [
                    .accent.opacity(0.2),
                    .accent.opacity(0.4),
                        .accent.opacity(0.6),
                        .accent.opacity(0.8),
                    .accent.opacity(1.0)]))
             */


        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            .frame(height: 300)
    }
}


struct VerticalItemGaugeView: View {

    @State var status: String
    @State var type: String
    @State var icon: String
    
    @Binding var value: Double
    
    var body: some View {
        VStack {
            HStack(spacing: 17) {
                
                Gauge(value: value, in: 0...100) {
                } currentValueLabel: {
                } minimumValueLabel: {
                } maximumValueLabel: {
                }
                .gaugeStyle(VerticalGaugeStyle())
                .frame(height: .infinity)
                
                VStack(spacing:12) {
                    Text(status)
                    Image(systemName: icon)
                        .font(.system(size: 30))
                        .foregroundColor(.accent)
                    
                    Text(type).font(.caption)

                }
            }.frame(maxHeight: 70)
            
            
        }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
    }
}

struct VerticalGaugeStyle: GaugeStyle {
    let dotWidth = 10.0
    let dotHeight = 5.0
    let dotDefaultColor = Color.gray.opacity(0.5)
    
    func makeBody(configuration: Configuration) -> some View {
        let value = configuration.value * 100
        VStack(spacing: 2) {

            Rectangle()
                .fill(value > 95.0 ? .accent.opacity(0.3) : dotDefaultColor)
                .frame(
                width: self.dotWidth,
                height: self.dotHeight)
            
            Rectangle()
                .fill(value > 85.0 ? .accent.opacity(0.4) : dotDefaultColor)
                .frame(
                width: self.dotWidth,
                height: self.dotHeight)
            
            Rectangle()
                .fill(value > 75.0 ? .accent.opacity(0.6) : dotDefaultColor)
                .frame(
                width: self.dotWidth,
                height: self.dotHeight)
            
            Rectangle()
                .fill(value > 40.0 ? .accent.opacity(0.8) : dotDefaultColor)
                .frame(
                width: self.dotWidth,
                height: self.dotHeight)
            
            Rectangle()
                .fill(value > 20.0 ? .accent.opacity(0.8) : dotDefaultColor)
                .frame(
                width: self.dotWidth,
                height: self.dotHeight)
            
            Rectangle()
                .fill(value > 10.0 ? .accent : dotDefaultColor)
                .frame(
                width: self.dotWidth,
                height: self.dotHeight)
            
        }
    }
}


#Preview {
    VerticalItemGauge()
}
