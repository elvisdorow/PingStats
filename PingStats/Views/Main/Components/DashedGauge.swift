//
//  TesteCircleView.swift
//  PingStats
//
//  Created by Elvis Dorow on 03/01/25.
//

import SwiftUI


struct DashedGauge: View {
    
    let type: String
    let icon: String

    @Binding var value: Double
    @Binding var status: PingStat.Status

    let size: Double = UIScreen.main.bounds.height * 0.11
    let iconSize = UIScreen.main.bounds.height * 0.035

    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                ZStack {
                    ForEach(0..<40) { i in
                        CircleDot(size: size, index: i, currVal: value)
                    }
                }
                .frame(width: size, height: size)
                .rotationEffect(.degrees(58))

                VStack(spacing: 4) {
                    Image(systemName: "\(icon)")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.primary.opacity(0.8))
                        .frame(width: iconSize, height: iconSize)

                    Text("\(type)")
                        .font(.caption)
                }

            }
            .frame(width: size, height: size)

            Text("\(status.rawValue)")
                .font(.footnote)
        }
    }
}

struct CircleDot: View {
    
    var size: Double
    var currentValue: Double
    var index: Int
    var indexValue: Double
    var onColor = Color.theme.accent
    var offColor = Color(.systemGray3)
    
 
    init(size: Double, index: Int, currVal: Double) {
        self.size = size
        self.index = index
        self.currentValue = currVal
        
        self.indexValue = Double(self.index) * 2.5
    }
 
    var body: some View {
        RoundedRectangle(cornerRadius: 1)
            .fill(LinearGradient(colors: [(self.indexValue < self.currentValue) ? onColor : offColor], startPoint: .bottom, endPoint: .top))
            .frame(width: 3.5, height: 9)
            .offset(x: 0, y: size/2)
            .rotationEffect(.degrees(Double(index) * 6.3), anchor: .center)
    }
}


struct DashedGauge_Previews: PreviewProvider {
    @State static var value = 0.0
    @State static var status = PingStat.Status.good
    
    static var previews: some View {
        DashedGauge(
            type: "Gaming",
            icon: "gamecontroller.fill",
            value: $value,
            status: $status)
    }
}
