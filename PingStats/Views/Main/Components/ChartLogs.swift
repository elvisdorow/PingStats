//
//  Chart.swift
//  PingStats
//
//  Created by Elvis Dorow on 11/11/24.
//

import SwiftUI
import Charts

struct ChartLogView: View {

    @EnvironmentObject var viewModel: MainViewModel
    @Environment(\.colorScheme) var colorScheme: ColorScheme
 
    var body: some View {
        HStack {
            if viewModel.chartType != .logs {
                Charts()
            } else {
                LogTable(logs: $viewModel.pingLogs)
                    .padding(.top, 10)
            }
        }
        
    }
}

struct Charts: View {
    
    @EnvironmentObject var viewModel: MainViewModel
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    var body: some View {
        Chart {
            ForEach(viewModel.chartItems) { data in
                if viewModel.chartType == .areaChart {
                    LineMark(
                        x: .value("seq", data.sequence),
                        y: .value("ms", data.duration.scaled(by: 1000))
                    )
                    .lineStyle(StrokeStyle(lineWidth: 2))
                    .foregroundStyle(.blue.opacity(0.7))
                    .interpolationMethod(.catmullRom)
                    AreaMark(
                        x: .value("seq", data.sequence),
                        y: .value("ms", data.duration.scaled(by: 1000))
                    )
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(LinearGradient(
                        gradient: Gradient(colors: [Color.theme.darkAccent.opacity(1.0), Color.theme.darkAccent.opacity(0.2)]),
                        startPoint: .top,
                        endPoint: .bottom
                    ))
                    
                } else {
                    if colorScheme == .dark {
                        BarMark(
                            x: .value("seq", data.sequence),
                            y: .value("ms", data.duration.scaled(by: 1000)),
                            width: 7
                        )
                        .foregroundStyle(LinearGradient(
                            gradient: Gradient(colors: [Color.theme.darkAccent.opacity(1.0), Color.theme.darkAccent.opacity(0.8)]),
                            startPoint: .top,
                            endPoint: .bottom
                        ))
                        
                        .clipShape(RoundedBottomRectangle(cornerRadius: 2))
                        .cornerRadius(3)
                    } else {
                        BarMark(
                            x: .value("seq", data.sequence),
                            y: .value("ms", data.duration.scaled(by: 1000)),
                            width: 7
                        )
                        .foregroundStyle(.accent.gradient)
                        
                        .clipShape(RoundedBottomRectangle(cornerRadius: 2))
                        .cornerRadius(3)

                    }
                    
                }
            }
        }
        .chartXAxis {
            AxisMarks {
                AxisGridLine()
            }
        }
        .chartYAxisLabel {
            Text("ms")
        }
    }
}


struct RoundedBottomRectangle: Shape {
    var cornerRadius: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()

        // Define the corner points
        let topLeft = CGPoint(x: rect.minX, y: rect.minY)
        let topRight = CGPoint(x: rect.maxX, y: rect.minY)
        let bottomRight = CGPoint(x: rect.maxX, y: rect.maxY - cornerRadius)
        let bottomLeft = CGPoint(x: rect.minX, y: rect.maxY - cornerRadius)

        // Start the path
        path.move(to: topLeft)
        path.addLine(to: topRight)
        path.addLine(to: bottomRight)
        path.addArc(
            center: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY - cornerRadius),
            radius: cornerRadius,
            startAngle: Angle(degrees: 0),
            endAngle: Angle(degrees: 90),
            clockwise: false
        )
        path.addLine(to: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY))
        path.addArc(
            center: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY - cornerRadius),
            radius: cornerRadius,
            startAngle: Angle(degrees: 90),
            endAngle: Angle(degrees: 180),
            clockwise: false
        )
        path.addLine(to: bottomLeft)

        return path
    }
}



