//
//  MySegmentedControl.swift
//  PingStats
//
//  Created by Elvis Dorow on 19/07/24.
//

import SwiftUI

struct SegmentedControl: View {
    
    enum SelectedControl: String {
        case areaChart = "areaChartIcon"
        case barChart = "barChartIcon"
        case logs = "logsChartIcon"
    }
    
    @Binding
    var selected: SelectedControl
    
    @State
    var underlinePos: Alignment = .leading
    
    @State
    var underlineXOffset: CGFloat = 35
    
    
    var body: some View {
        VStack(spacing: 3) {
            HStack(spacing:0) {
                
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
                        self.underlinePos = .leading
                        self.underlineXOffset = 35
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
                        self.underlineXOffset = -35
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



struct SegmentedControl2: View {
    enum SegmentedOptions: String, CaseIterable {
        case barChart = "barChartIcon"
        case areaChart = "areaChartIcon"
        case logs = "logsChartIcon"
    }

    @Binding var selected: SegmentedOptions
    
    let width: CGFloat

    private var itemWidth: CGFloat {
        width / CGFloat(SegmentedOptions.allCases.count)
    }

    var body: some View {
        let selectedItem = SegmentedOptions.allCases.firstIndex(of: selected) ?? 0
        let underlineWidth = itemWidth * 0.5

        VStack(spacing: 0) {
            // Segmented buttons
            HStack(spacing: 0) {
                ForEach(SegmentedOptions.allCases, id: \.self) { item in
                    segmentedButton(option: item)
                        .onTapGesture {
                            self.selected = item // Update the selected item
                        }
                }
            }
            .frame(width: width)

            // Underline
            RoundedRectangle(cornerRadius: 2)
                .frame(width: underlineWidth, height: 3)
                .foregroundColor(.primary)
                .offset(x: CGFloat(selectedItem) * itemWidth - (width / 2) + (itemWidth / 2))
                .animation(.spring(duration: 0.1), value: selected)
        }
        .frame(height: 50)
    }

    func segmentedButton(option: SegmentedOptions) -> some View {
        VStack {
            Image(option.rawValue)
                .resizable()
                .scaledToFit()
                .frame(width: 27, height: 27)
                .foregroundColor(option == selected ? .blue : .gray)
                .opacity(option == selected ? 1.0 : 0.4)
        }
        .frame(width: itemWidth, height: 30)
    }
}

struct SegmentedControl2_Previews: PreviewProvider {
    @State static var selected = SegmentedControl2.SegmentedOptions.barChart

    static var previews: some View {
        SegmentedControl2(selected: $selected, width: 250)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}


//struct SegmentControlPreview: PreviewProvider {
//    @State static var type = SegmentedControl.SelectedControl.areaChart
//    
//    static var previews: some View {
//        Group {
//            SegmentedControl(selected: $type)
//                .frame(maxWidth: 200)
//        }
//            
//    }
//}

