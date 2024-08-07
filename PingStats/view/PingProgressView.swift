//
//  PingProgressView.swift
//  PingStats
//
//  Created by Elvis Dorow on 23/07/24.
//

import SwiftUI

struct PingProgressView: View {
    
    @Binding var currentValue: Double
    
    var body: some View {
        ProgressView(value: currentValue, total: 100.0)
            .progressViewStyle(PingProgressViewStyle())
    }
}

struct PingProgressViewStyle: ProgressViewStyle {
    
    let stops = [Gradient.Stop(color: .red, location: 0.0),
                 Gradient.Stop(color: .red, location: 0.25),
                 Gradient.Stop(color: .orange, location: 0.25),
                 Gradient.Stop(color: .orange, location: 0.5),
                 Gradient.Stop(color: .yellow, location: 0.5),
                 Gradient.Stop(color: .yellow, location: 0.80),
                 Gradient.Stop(color: .green, location: 0.80),
                 Gradient.Stop(color: .green, location: 1.0),
 ]
    
    func makeBody(configuration: Configuration) -> some View {
        GeometryReader { geometry in
            let completed = configuration.fractionCompleted ?? 0.1
                
            ZStack {
                // Background path (gray dashed line)
                Path { path in
                    path.move(to: CGPoint(x: 0, y: geometry.size.height / 2))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height / 2))
                }
                .stroke(style: StrokeStyle(lineWidth:10, lineCap: .round, dash: [19,30]))
                .foregroundColor(Color(.lightGray))

                // Foreground path (colored dashed line)
                Path { path in
                    path.move(to: CGPoint(x: 0, y: geometry.size.height / 2))
                    path.addLine(to: CGPoint(x: geometry.size.width * completed, y: geometry.size.height / 2))
                }
                .stroke(
                    LinearGradient(
                        stops: stops,
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    style: StrokeStyle(lineWidth: 20, lineJoin: .round, dash: [5, 2], dashPhase: 0.5)
                )
                .animation(.linear, value: completed)
            }
        }
    }
}

struct PingProgressViewtest: PreviewProvider {
    @State static var value = 0.0
    static var previews: some View {
        PingProgressView(currentValue: $value)
    }
}

