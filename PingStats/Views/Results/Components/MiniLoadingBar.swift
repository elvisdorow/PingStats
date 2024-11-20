//
//  MiniLoadingBar.swift
//  PingStats
//
//  Created by Elvis Dorow on 19/11/24.
//

import SwiftUI

struct MiniLoadingBar: View {
    
    @State var currentValue: Double
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 3)
                .fill(getColor())
                .frame(width: currentValue, height: 7)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func getColor() -> Color {
        switch(currentValue) {
        case 0...40:
            return .red
        case 41...60:
            return .orange
        case 61...80:
            return .yellow
        case 81...100:
            return .green
        default:
            return .gray
        }
    }
}
#Preview {
    MiniLoadingBar(currentValue: 56)
}
