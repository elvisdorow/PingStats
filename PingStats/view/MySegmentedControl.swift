//
//  MySegmentedControl.swift
//  PingStats
//
//  Created by Elvis Dorow on 19/07/24.
//

import SwiftUI

struct MySegmentedControl: View {
    
    enum SelectedControl {
        case areaChart, barChart, logs
    }
    
    @Binding
    var selected: SelectedControl
    
    @State
    var underlinePos: Alignment = .leading
    
    @State
    var underlineXOffset: CGFloat = 20
    
    
    
    var body: some View {
        VStack(spacing: 3) {
            HStack(spacing:0) {
                VStack(spacing: 5) {
                    Image("areaChartIcon")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.primary)
                        .opacity(self.selected == .areaChart ? 1.0 : 0.4)
                }
                .frame(maxWidth: 100)
                .onTapGesture {
                    withAnimation(.spring) {
                        self.selected = .areaChart
                        self.underlinePos = .leading
                        self.underlineXOffset = 20
                    }
                }
                
                VStack(spacing: 5) {
                    Image("barChartIcon")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.primary)
                        .opacity(self.selected == .barChart ? 1.0 : 0.4)
                }
                .frame(maxWidth: 100)
                .onTapGesture {
                    withAnimation(.spring) {
                        self.selected = .barChart
                        self.underlinePos = .center
                        self.underlineXOffset = 0
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
                        self.underlinePos = .trailing
                        self.underlineXOffset = -20
                    }
                }
            }
            
            HStack {
                Rectangle()
                    .frame(height: 2)
                    .frame(maxWidth: 30, alignment: .leading)
                    .cornerRadius(30)
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: underlinePos)
            .offset(x: underlineXOffset)
            
        }.frame(maxWidth: 200)
    }
}

struct SegmentControlPreview: PreviewProvider {
    @State static var type = MySegmentedControl.SelectedControl.areaChart
    static var previews: some View {
        MySegmentedControl(selected: $type)

    }
}

