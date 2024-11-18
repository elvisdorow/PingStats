//
//  PingStatBlock.swift
//  PingStats
//
//  Created by Elvis Dorow on 11/11/24.
//

import SwiftUI

struct TextStatInfo: View {
    
    var statusTitle: String
    var pingValue: String
    var fontSize: CGFloat
    var fontWeight: Font.Weight
    
    init(statusTitle: String, pingValue: String, fontSize: CGFloat = 23, fontWeight: Font.Weight = .light) {
        self.statusTitle = statusTitle
        self.pingValue = pingValue
        self.fontSize = fontSize
        self.fontWeight = fontWeight
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 4) {
            
            Text("\(pingValue)")
                .font(.system(size: fontSize, weight: fontWeight, design: .rounded))
            
            Text(statusTitle)
                .font(.custom("Inter-Regular", size: 13))

        }
        .frame(maxWidth: .infinity, alignment: .center)

    }
}
