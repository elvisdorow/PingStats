//
//  MySegmentedControl.swift
//  PingStats
//
//  Created by Elvis Dorow on 19/07/24.
//

import SwiftUI

struct MySegmentedControl: View {
    
    enum SelectedControl {
        case chart, logs
    }
    
    @State
    var selected: SelectedControl = .chart
    
    var body: some View {
        VStack(spacing: 3) {
            HStack(spacing:0) {
                VStack(spacing: 5) {
                    Image("areaChartIcon")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.primary)
                        .opacity(self.selected == .chart ? 1.0 : 0.4)
                }
                .frame(maxWidth: 100)
                .onTapGesture {
                    withAnimation(.spring) {
                        self.selected = .chart

                    }
                }
                
                VStack(spacing: 5) {
                    Image(systemName: "text.justify.leading")
                        .opacity(self.selected == .logs ? 1.0 : 0.4)
                }
                .frame(maxWidth: 100)
                .onTapGesture {
                    withAnimation(.spring) {
                        self.selected = .logs

                    }
                }
            }
            
            HStack {
                Rectangle()
                    .frame(height: 2)
                    .frame(maxWidth: 60, alignment: .leading)
                    .cornerRadius(30)
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: selected == .chart ? .leading : .trailing)
            .offset(x: selected == .chart ? 20 : -20)
            
        }.frame(maxWidth: 200)
    }
}

#Preview {
    MySegmentedControl()
}
