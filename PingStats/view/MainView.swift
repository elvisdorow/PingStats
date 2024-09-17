//
//  ContentView.swift
//  PingStats
//
//  Created by Elvis Dorow on 15/07/24.
//

import SwiftUI
import Charts
import RealmSwift

struct MainView: View {
    
    @State private var selectedSegment = 1
    @State private var showLogs = false
    
    @State private var showSettingsView: Bool = false
    @State private var showResultsView: Bool = false
    
    @StateObject var viewModel = MainViewModel()
    @StateObject var settingsViewModel = SettingsViewModel()
    
    var body: some View {
        NavigationStack {
            
            ZStack {
                RadialGradient(gradient: Gradient(colors: [Color(.systemBackground), Color(.systemGray6)]),
                               center: .topLeading,
                               startRadius: 0,
                               endRadius: 900).ignoresSafeArea()
                
                VStack(spacing: 0) {
                    MySegmentedControl(selected: $viewModel.chartType)
                        .padding(.top, 15)
                        .padding(.leading, 10)
                    
                    ChartLogView()
                        .frame(height: UIScreen.main.bounds.height * 0.15)
                        .padding(.horizontal)
                        .padding(.bottom)
                    
                    Text("\(viewModel.statusMessage)")
                            .font(.caption)
                            .foregroundColor(.primary.opacity(0.6))
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                            .padding(.horizontal)
                    
                    Spacer()

                    VStack(alignment: .leading) {
                        Label(
                            title: {
                                Text("Network Quality")
                                    .foregroundStyle(.primary.opacity(0.87))
                                    .font(.subheadline)
                                    .fontWeight(.light)
                            },
                            icon: { Image(systemName: "wifi") }
                        )
                        HStack {
                            ConnectionQuality()
                            Text("\(Formatter.number(viewModel.stat.generalNetQuality, fraction: 0, unit: "%"))")
                                .frame(width: 55)
                        }
                    }
                    .padding()

                    Spacer()
                    
                    NetQualityView()
                    .frame(height: UIScreen.main.bounds.height * 0.145)
                    .padding(.horizontal)
                    .padding(.top, 6)
                    
                    Spacer()
                    
                    DetailedStatsView()
                    
                    Spacer()

                    ActionControlView()

                }
                .environmentObject(viewModel)
                .environmentObject(settingsViewModel)
                .toolbar(content: {
                    
                    ToolbarItem(placement: .topBarLeading) {
                        HStack {
                            Image("logo")
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Menu {
                            Button(action: {
                                showSettingsView.toggle()
                            },
                            label: {
                                Label(
                                    title: { Text("Settings") },
                                    icon: { Image(systemName: "gear") }
                                )
                            })
                            Button(action: {
                                showResultsView.toggle()
                            },
                            label: {
                                Label(
                                    title: { Text("Results") },
                                    icon: { Image(systemName: "list.bullet.rectangle.portrait") }
                                )
                            })
                            Button(action: {},
                            label: {
                                Label(
                                    title: { Text("About") },
                                    icon: { Image(systemName: "info.circle") }
                                )
                            })

                        } label: {
                            Label(
                                title: { Text("Menu") },
                                icon: { Image("menuDotsIcon") }
                            )
                        }

                    }
                    }).accentColor(.primary)
            }
            .popover(isPresented: $showSettingsView) {
                SettingsView()
                    .environmentObject(settingsViewModel)  
                    .presentationCompactAdaptation(.fullScreenCover)
            }
            .popover(isPresented: $showResultsView) {
                ResultListView()
                    .presentationCompactAdaptation(.fullScreenCover)
            }
            
        }.preferredColorScheme(settingsViewModel.theme != .system ? (settingsViewModel.theme == .darkMode ? .dark : .light) : nil)
    }
}

struct ConnectionQuality: View {

    @EnvironmentObject var viewModel: MainViewModel

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            LoadingBarView(currentValue: $viewModel.stat.generalNetQuality)
                .frame(height: 20)
//            PingProgressView(currentValue: $viewModel.stat.generalNetQuality)
        }
    }
}

struct ChartLogView: View {

    @EnvironmentObject var viewModel: MainViewModel
 
    var body: some View {
        HStack {
            if viewModel.chartType != .logs {
                Chart {
                    ForEach(viewModel.chartItems) { data in
                        if viewModel.chartType == .areaChart {
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
                                gradient: Gradient(colors: [Color("DarkAccentColor").opacity(0.3), Color("DarkAccentColor").opacity(0.05)]),
                                startPoint: .top,
                                endPoint: .bottom
                            ))
                            
                        } else {
                            BarMark(
                                x: .value("seq", data.sequency),
                                y: .value("ms", data.duration.scaled(by: 1000)),
                                width: 4
                            )
                            .foregroundStyle(.accent)
                            .clipShape(RoundedBottomRectangle(cornerRadius: 3))
                            .cornerRadius(3)
                            
                        }
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

            } else {
                LogTableView(logs: $viewModel.logs)
                    .padding(.top, 10)
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
            Spacer()
            CircularGaugeItem(
                type: "Video Call",
                icon: "video.badge.waveform.fill",
                value: $viewModel.stat.videoCallScore,
                status: $viewModel.stat.videoCallStatus
            )
            Spacer()
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
    let lineHeight = 40.0
    
    var body: some View {
        
        VStack(alignment: .center , spacing: 0) {
            HStack {
                PingStatBlock(
                    statusTitle: "Best Ping",
                    pingValue: "\(Formatter.number(viewModel.stat.bestPing, fraction: 0, unit: "ms"))")

                Rectangle().fill(Color.gray.opacity(0.2)).frame(width: 1, height: lineHeight)
                
                PingStatAvgBlock(
                    statusTitle: "Avarage Ping",
                    pingValue: "\(Formatter.number(viewModel.stat.avaragePing, fraction: 0, unit: "ms"))")

                Rectangle().fill(Color.gray.opacity(0.2)).frame(width: 1, height: lineHeight)
                
                PingStatBlock(
                    statusTitle: "Worst Ping",
                    pingValue: "\(Formatter.number(viewModel.stat.worstPing, fraction: 0, unit: "ms"))"
                )

            }
            .frame(minHeight: lineHeight, alignment: .center)
            .frame(maxHeight: 80)

            Rectangle().fill(Color.gray.opacity(0.2))
                .frame(height: 1)
            
            HStack {
                PingStatBlock(
                    statusTitle: "Package Loss",
                    pingValue: "\(Formatter.number(viewModel.stat.packageLoss, fraction: 1, unit: "%"))")
                
                Rectangle().fill(Color.gray.opacity(0.1)).frame(width: 1, height: lineHeight)
                
                PingStatBlock(
                    statusTitle: "Jitter",
                    pingValue: "\(Formatter.number(viewModel.stat.jitter, fraction: 0, unit: "ms"))")
                
                Rectangle().fill(Color.gray.opacity(0.1)).frame(width: 1, height: lineHeight)
                
                PingStatBlock(
                    statusTitle: "Elapsed Time",
                    pingValue: "\(Formatter.elapsedTime(viewModel.elapsedTime))"
                )
                .onReceive(viewModel.timer) { _ in
                    viewModel.elapsedTime = Date().timeIntervalSince(viewModel.startTime)
                }
            }
            .frame(minHeight: lineHeight, alignment: .center)
            .frame(maxHeight: 80)
        }
    }
}



struct PingStatBlock: View {
    
    var statusTitle: String
    var pingValue: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 4) {
            
            Text("\(pingValue)")
                .font(.system(size: 23, weight: .light, design: .rounded))
            
            Text(statusTitle)
                .font(.custom("Inter-Regular", size: 13))

        }
        .frame(maxWidth: .infinity, alignment: .center)

    }
}

struct PingStatAvgBlock: View {
    
    var statusTitle: String
    var pingValue: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            
            Text("\(pingValue)")
                .font(.system(size: 30, weight: .regular, design: .rounded))

            Text(statusTitle)
                .font(.custom("Inter-Regular", size: 13))

        }
        .frame(maxWidth: .infinity, alignment: .top)

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
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    
    @State var showHostList: Bool = false
    
    var body: some View {
        HStack(spacing: 30) {
            
            VStack(alignment: .leading) {
                Text("IP Address or Host Name:")
                    .font(.caption)
                
                HStack(alignment: .firstTextBaseline) {
                    Image(systemName: "server.rack").opacity(0.6)
                    Text("\(settingsViewModel.selectedIpAddress)")
                        .foregroundColor(viewModel.isAnalysisRunning ? .primary.opacity(0.3) : .primary)
                        . multilineTextAlignment(.leading)
                }
                .padding(.leading, 8)
                .frame(height: 40)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                .background(viewModel.isAnalysisRunning ? Color(.systemGray4).opacity(0.4): Color(.systemGray4))
                .cornerRadius(5.0)
                .onTapGesture {
                    if !viewModel.isAnalysisRunning {
                        showHostList.toggle()
                    }
                }
                .sheet(isPresented: $showHostList) {
                    NavigationView {
                        IPAddressesView()
                            .environmentObject(settingsViewModel)
                            .navigationTitle("Hosts")
                            .navigationBarTitleDisplayMode(.inline)
                            .toolbar(content: {
                                ToolbarItem(placement: .cancellationAction) {
                                    Button {
                                        showHostList = false
                                    } label: {
                                        Text("Done")
                                    }
                                }
                            })
                            .onAppear {
                                settingsViewModel.objectWillChange.send()
                            }
                    }
                }
            }
            HStack {
                PlayButtonView(running: $viewModel.isAnalysisRunning)
                    .offset(y: 8)
                    .onTapGesture {
                        let generator = UIImpactFeedbackGenerator(style: .light)
                        generator.prepare()
                        generator.impactOccurred()
                        
                        if viewModel.isAnalysisRunning {
                            viewModel.stop()
                        } else {
                            viewModel.start(settingsViewModel)
                        }
                    }
            }

        }
        .padding(.horizontal)
        .padding(.bottom)
        .frame(maxWidth: .infinity)
    }
}

struct DottedLineView: View {
    var body: some View {
        Path { path in
            path.move(to: CGPoint(x: 20, y: 100))
            path.addLine(to: CGPoint(x: 300, y: 100))
        }
        .stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round, dash: [5, 5]))
        .foregroundColor(.blue)
    }
}

#Preview {
    MainView()
}

#Preview {
    MainView().preferredColorScheme(.dark)
}
