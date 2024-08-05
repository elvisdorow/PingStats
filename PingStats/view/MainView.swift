//
//  ContentView.swift
//  PingStats
//
//  Created by Elvis Dorow on 15/07/24.
//

import SwiftUI
import Charts

struct MainView: View {
    
    @State private var selectedSegment = 1
    @State private var showLogs = false
    
    @StateObject var viewModel: MainViewModel = MainViewModel()
    
    var body: some View {
        NavigationStack {
            
            ZStack {
                RadialGradient(gradient: Gradient(colors: [Color(.systemBackground), Color(.systemGray6)]),
                               center: .topLeading,
                               startRadius: 0,
                               endRadius: 900).ignoresSafeArea()
                
                VStack(spacing: 0) {
                    MySegmentedControl(selected: .chart)
                        .padding(.top, 20)
                        .padding(.leading, 10)
                    
                    ChartLogView()
                        .frame(height: UIScreen.main.bounds.height * 0.15)
                        .padding(.horizontal)
                        .padding(.bottom)

                    GroupBox(label: Label(
                        title: { Text("Connection Stability") },
                        icon: { Image(systemName: "network") }
                    ), content: {
                        HStack {
                            ConnectionQuality()
                            Text("\(formatNumbers(viewModel.stat.generalNetQuality, fraction: 0, unit: "%"))")
                        }
                    })
                    .frame(minHeight: 100)
                    .frame(maxHeight: UIScreen.main.bounds.height * 0.12)
                    .padding(.horizontal)

                    Spacer()
                    
                    NetQualityView()
                    .frame(height: UIScreen.main.bounds.height * 0.14)
                    .padding(.top, 15)
                    
                    Spacer()
                    
                    DetailedStatsView()
                    
                    Spacer()

                    ActionControlView()

                }
                .environmentObject(viewModel)
                .toolbar(content: {
                    ToolbarItem(placement: .topBarLeading) {
                                       HStack {
                                           Text("Ping Stats")
                                               .font(.title)
                                               .fontWeight(.bold)
                                       }
                                   }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {}, label: {
                            Image(systemName: "gear")
                        })
                    }
                    }).accentColor(.primary)

            }
        }
    }
}

struct ConnectionQuality: View {

    @EnvironmentObject var viewModel: MainViewModel

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            PingProgressView(currentValue: $viewModel.stat.generalNetQuality)
        }
    }
}

struct ChartLogView: View {

    @EnvironmentObject var viewModel: MainViewModel
 
    var body: some View {
        HStack {
            Chart {
                ForEach(viewModel.chartItems) { data in
                    LineMark(
                        x: .value("seq", data.sequency),
                        y: .value("ms", data.duration.scaled(by: 1000))
                    )
                    .lineStyle(StrokeStyle(lineWidth: 2))
                    .foregroundStyle(.blue.opacity(0.7))
                    .interpolationMethod(.catmullRom)
                    AreaMark(
                        x: .value("seq", data.sequency),
                        y: .value("ms", data.duration.scaled(by: 1000))
                    )
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(LinearGradient(
                        gradient: Gradient(colors: [.accent.opacity(0.3), .accent.opacity(0.05)]),
                                   startPoint: .top,
                                   endPoint: .bottom
                               ))

//                    BarMark(
//                        x: .value("seq", data.sequency),
//                        y: .value("ms", data.duration.scaled(by: 1000)),
//                        width: 4
//                    )
//                    .foregroundStyle(Color.accent)
//                    .clipShape(RoundedBottomRectangle(cornerRadius: 3))
//                    .cornerRadius(3)

                }
            }
            .chartXAxis {
                AxisMarks {
                    AxisGridLine()
                }
            }
            .chartXScale(domain: 1...(viewModel.chartItems.count))
            .chartYAxisLabel {
                Text("ms")
            }
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

struct NetQualityView: View {
    
    @EnvironmentObject var viewModel: MainViewModel
    
    var body: some View {
        HStack(spacing: 0) {
            CircularGaugeItem(
                type: "Gaming",
                icon: "gamecontroller.fill",
                value: $viewModel.stat.gamingScore,
                status: $viewModel.stat.gamingStatus
            )
            CircularGaugeItem(
                type: "Video Call",
                icon: "video.badge.waveform.fill",
                value: $viewModel.stat.videoCallScore,
                status: $viewModel.stat.videoCallStatus
            )
            CircularGaugeItem(
                type: "Streaming",
                icon: "play.tv.fill",
                value: $viewModel.stat.streamingScore,
                status: $viewModel.stat.streamingStatus
            )
        }
    }
}


struct DetailedStatsView: View {
    
    @EnvironmentObject var viewModel: MainViewModel
    
    var body: some View {
        
        VStack(alignment: .center , spacing: 0) {
            HStack {
                PingStatBlock(
                    statusTitle: "Best Ping",
                    pingValue: "\(formatNumbers(viewModel.stat.bestPing, fraction: 0, unit: "ms"))")

                Rectangle().fill(Color.gray.opacity(0.2)).frame(width: 1, height: 60)
                
                PingStatBlock(
                    statusTitle: "Avarage Ping",
                    pingValue: "\(formatNumbers(viewModel.stat.avaragePing, fraction: 0, unit: "ms"))")

                Rectangle().fill(Color.gray.opacity(0.2)).frame(width: 1, height: 60)
                
                PingStatBlock(
                    statusTitle: "Worst Ping",
                    pingValue: "\(formatNumbers(viewModel.stat.worstPing, fraction: 0, unit: "ms"))"
                )

            }
            .frame(minHeight: 50, alignment: .center)
            .frame(maxHeight: .infinity)

            Rectangle().fill(Color.gray.opacity(0.2))
                .frame(height: 1)
            
            HStack {
                PingStatBlock(
                    statusTitle: "Package Loss",
                    pingValue: "\(formatNumbers(viewModel.stat.packageLoss, fraction: 1, unit: "%"))")
                
                Rectangle().fill(Color.gray.opacity(0.1)).frame(width: 1, height: 60)
                
                PingStatBlock(
                    statusTitle: "Jitter",
                    pingValue: "\(formatNumbers(viewModel.stat.jitter, fraction: 0, unit: "ms"))")
                
                Rectangle().fill(Color.gray.opacity(0.1)).frame(width: 1, height: 60)
                
                PingStatBlock(
                    statusTitle: "Elapsed Time",
                    pingValue: "\(formattedElapsedTime(viewModel.elapsedTime))"
                )
                .onReceive(viewModel.timer) { _ in
                    viewModel.elapsedTime = Date().timeIntervalSince(viewModel.startTime)
                }


            }
            .frame(minHeight: 50, alignment: .center)
            .frame(maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        }
    }
        
    func formattedElapsedTime(_ timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = (Int(timeInterval) % 3600) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

func formatNumbers(_ number: Double, fraction: Int, unit: String, separator: String = ".") -> String {
    if number >= 0 {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = fraction
        formatter.maximumFractionDigits = fraction
        formatter.decimalSeparator = separator
        let formattedNumber = formatter.string(from: NSNumber(value: number))
        
        if let strNumber = formattedNumber {
            return "\(strNumber) \(unit)"
        }
    }
    return "--"
}



struct PingStatBlock: View {
    
    var statusTitle: String
    var pingValue: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 4) {
            Text(statusTitle)
                .font(.caption)
            
            Text("\(pingValue)")
                .font(.system(size: 23, weight: .light))
        }
        .frame(maxWidth: .infinity, alignment: .center)

    }
}


struct CustomSegmentedControl: View {
    @Binding var preselectedIndex: Int
    var options: [String]
    let color = Color(.systemGroupedBackground)

    var body: some View {
        HStack(spacing: 0) {
            ForEach(options.indices, id:\.self) { index in
                ZStack {
                    Rectangle()
                        .fill(color.opacity(0.1))

                    Rectangle()
                        .fill(color)
                        .cornerRadius(10)
                        .padding(2)
                        .opacity(preselectedIndex == index ? 1 : 0.3)
                        .onTapGesture {
                                withAnimation(.interactiveSpring()) {
                                    preselectedIndex = index
                                }
                            }
                }
                .overlay(
                    Text(options[index]).font(.subheadline)
                )
            }
        }
        .frame(height: 30)
        .frame(maxWidth: 140)
        .cornerRadius(4)
    }
}


struct VerticalAccessoryGaugeStyle: GaugeStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(spacing: 0) {
            configuration.maximumValueLabel
            GeometryReader { proxy in
                Capsule()
                    .fill(.tint)
                    .rotationEffect(.degrees(180))
                Circle()
                    .stroke(.background, style: StrokeStyle(lineWidth: 3))
                    .position(x: 5, y: proxy.size.height * (1 - configuration.value))
            }
            .frame(width: 10)
            .clipped()
            configuration.minimumValueLabel
        }
    }
}

struct ActionControlView: View {
    
    @EnvironmentObject var viewModel: MainViewModel
    
    var body: some View {
        HStack(spacing: 30) {
            
            VStack(alignment: .leading) {
                Text("IP Address or Host Name:")
                    .font(.caption)
                
                HStack {
                    Image(systemName: "pc").opacity(0.6)
                    TextField(text: $viewModel.hostAddress, label:  {
                        Text("0.0.0.0")
                    })
                    .foregroundColor(viewModel.isAnalysisRunning ? .primary.opacity(0.3) : .primary)
                    .disabled(viewModel.isAnalysisRunning)
                }
                .padding(.leading, 8)
                .frame(height: 40)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                .background(viewModel.isAnalysisRunning ? Color(.systemGray4).opacity(0.4): Color(.systemGray4))
                .cornerRadius(5.0)
                .overlay {
                }
            }
            HStack {
                PlayButtonView(running: $viewModel.isAnalysisRunning)
                    .offset(y: 8)
                    .onTapGesture {
                        if viewModel.isAnalysisRunning {
                            viewModel.stop()
                        } else {
                            viewModel.start()
                        }
                    }
            }

        }
        .padding(.horizontal)
        .padding(.bottom)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    MainView()
}

#Preview {
    MainView().preferredColorScheme(.dark)
}
