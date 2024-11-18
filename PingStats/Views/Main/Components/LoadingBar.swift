//
//  LoadingBarView.swift
//  PingStats
//
//  Created by Elvis Dorow on 07/08/24.
//

import SwiftUI

struct LoadingBar: View {
    
    @Binding var currentValue: Double
    
    var body: some View {
        HStack(spacing: UIScreen.main.bounds.width * 0.005) {
            ForEach(0..<40) { idx in
                DotMark(index: idx, currVal: currentValue)
            }
        }
    }
}

struct DotMark: View {
    var currentValue: Double
    var index: Int
    var onColor: Color
    var offColor = Color(.systemGray3)
    
    init(index: Int, currVal: Double) {
        self.index = index
        self.currentValue = currVal
        
        switch(index) {
        case 0...10:
            onColor = .red
        case 11...20:
            onColor = .orange
        case 21...30:
            onColor = .yellow
        case 31...40:
            onColor = .green
        default:
            onColor = .gray
        }
    }
    
    var body: some View {
        let valueRepresented = Double(index) * 2.5
        let dotColor: Color = valueRepresented < currentValue ? onColor : offColor
 
        Rectangle()
            .fill(dotColor)
            .cornerRadius(7)
    }
}

struct LoadingBarPreview: PreviewProvider {
    @State static var currentValue = 87.0
    
    static var previews: some View {
        LoadingBar(currentValue: $currentValue).frame(height: 20)
    }
}
