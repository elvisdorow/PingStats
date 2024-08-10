//
//  PlayButtonView.swift
//  PingStats
//
//  Created by Elvis Dorow on 24/07/24.
//

import SwiftUI

struct PlayButtonView: View {
    
    @Binding var running: Bool
    
    var body: some View {
        Circle()
            .fill(.accent.gradient)
            .frame(width: 60, height: 60)
            .shadow(radius: 4, x: 2, y: 4)
            .overlay(alignment: .center) {
                Image(systemName: running ? "stop.fill"  : "play.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color(.white))
                    .frame(width: 25, height: 25)
                    .offset(x: running ? 0 : 4)

            }
    }
}
