//
//  ContentView.swift
//  PingStats
//
//  Created by Elvis Dorow on 15/07/24.
//

import SwiftUI
import Charts

struct MainView: View {
    
    // TODO: Fix bug - can change host and any configuration
    // while test running
    
    @State private var selectedSegment = 1
    @State private var showLogs = false
    
    @State private var showSettingsView: Bool = false
    @State private var showResultsView: Bool = false
    
    @State private var showHostList: Bool = false
    
    @StateObject var viewModel: MainViewModel = MainViewModel()
    @StateObject var settings = Settings.shared

    var body: some View {
        NavigationStack {
            
            ZStack {
                RadialGradient(gradient: Gradient(colors: [Color.theme.backgroundTop, Color.theme.backgroundBottom]),
                               center: .topLeading,
                               startRadius: 0,
                               endRadius: 900).ignoresSafeArea()
                
                VStack(spacing: 0) {
                    
                    chartLogView
                    
                    Spacer()

                    horizontalChartNetQualityView

                    Spacer()
                    
                    gaugesView
                    
                    Spacer()
                    
                    textStatsView
                    
                    Spacer()

                    bottomActions

                }
                .environmentObject(viewModel)
                .toolbar(content: {
                    
                    ToolbarItem(placement: .topBarLeading) {
                        HStack {
                            Image("logo")
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        menuItems
                    }
                })
            }
            .popover(isPresented: $showSettingsView) {
                SettingsView()
                    .presentationCompactAdaptation(.fullScreenCover)
            }
            .popover(isPresented: $showResultsView) {
                ResultListView()
                    .presentationCompactAdaptation(.fullScreenCover)
            }

        }
    }
}

// MARK: Extensions

extension MainView {
    
    @ViewBuilder
    var menuItems: some View {
        Menu {
            Button(action: {
                showResultsView.toggle()
            },
                   label: {
                Label(
                    title: { Text("Results") },
                    icon: { Image(systemName: "list.bullet.rectangle.portrait") }
                )
            })
            Button(action: {
                showSettingsView.toggle()
            },
                   label: {
                Label(
                    title: { Text("Settings") },
                    icon: { Image(systemName: "gear") }
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
    
    @ViewBuilder
    var chartLogView: some View {
        
        SegmentedControl(selected: $viewModel.chartType)
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
    }
    
    @ViewBuilder
    var horizontalChartNetQualityView: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .firstTextBaseline, spacing: 15) {
                Text("Network Quality")
                    .font(.callout)
                    .foregroundStyle(.primary.opacity(0.8))
                    .fontWeight(.light)
                
                Spacer()
                
                Label(
                    title: {
                        Text("\(viewModel.connectionType.toString())")
                    },
                    icon: {
                        switch viewModel.connectionType {
                        case .wifi:
                            Image(systemName: "wifi")
                        case .cellular:
                            Image(systemName: "cellularbars")
                        case .ethernet:
                            Image(systemName: "cable.connector")
                        case .unknown:
                            Image(systemName: "network.slash")
                        }
                    }
                )
                .font(.system(size: 15))
                .foregroundStyle(.primary.opacity(0.9))
                .fontWeight(.light)
                .padding(.trailing, 0)
                
                
            }
            HStack {
                VStack(alignment: .center, spacing: 0) {
                    LoadingBar(currentValue: $viewModel.pingStat.generalScore)
                        .frame(height: 20)
                }
                Text("\(Formatter.number(viewModel.pingStat.generalScore, fraction: 0, unit: "%"))")
                    .frame(width: 55)
            }
        }
        .padding()
    }
    
    @ViewBuilder
    var gaugesView: some View {
        HStack(spacing: 0) {
            CircularGauge(
                type: "Gaming",
                icon: "gamecontroller.fill",
                value: $viewModel.pingStat.gamingScore,
                status: $viewModel.pingStat.gamingStatus
            )
//            Text("\(viewModel.pingStat.gamingScore)")
            Spacer()
            CircularGauge(
                type: "Video Call",
                icon: "video.badge.waveform.fill",
                value: $viewModel.pingStat.videoCallScore,
                status: $viewModel.pingStat.videoCallStatus
            )
            Spacer()
            CircularGauge(
                type: "Streaming",
                icon: "play.tv.fill",
                value: $viewModel.pingStat.streamingScore,
                status: $viewModel.pingStat.streamingStatus
            )
        }
        .frame(height: UIScreen.main.bounds.height * 0.145)
        .padding(.horizontal)
        .padding(.top, 6)
    }
    
    @ViewBuilder
    var textStatsView: some View {
        let lineHeight = 40.0
        
        VStack(alignment: .center , spacing: 0) {
            HStack {
                TextStatInfo(
                    statusTitle: "Best",
                    pingValue: "\(Formatter.number(viewModel.pingStat.bestPing, fraction: 0, unit: "ms"))")
                
                Rectangle().fill(Color.gray.opacity(0.2)).frame(width: 1, height: lineHeight)
                
                TextStatInfo(
                    statusTitle: "Avarage",
                    pingValue: "\(Formatter.number(viewModel.pingStat.averagePing, fraction: 0, unit: "ms"))",
                    fontSize: 30,
                    fontWeight: .regular
                )
                
                Rectangle().fill(Color.gray.opacity(0.2)).frame(width: 1, height: lineHeight)
                
                TextStatInfo(
                    statusTitle: "Worst",
                    pingValue: "\(Formatter.number(viewModel.pingStat.worstPing, fraction: 0, unit: "ms"))"
                )
                
            }
            .frame(minHeight: lineHeight, alignment: .center)
            .frame(maxHeight: 80)
            
            Rectangle().fill(Color.gray.opacity(0.2))
                .frame(height: 1)
            
            HStack {
                TextStatInfo(
                    statusTitle: "Package Loss",
                    pingValue: "\(Formatter.number(viewModel.pingStat.packageLoss, fraction: 1, unit: "%"))")
                
                Rectangle().fill(Color.gray.opacity(0.1)).frame(width: 1, height: lineHeight)
                
                TextStatInfo(
                    statusTitle: "Jitter",
                    pingValue: "\(Formatter.number(viewModel.pingStat.jitter, fraction: 0, unit: "ms"))")
                
                Rectangle().fill(Color.gray.opacity(0.1)).frame(width: 1, height: lineHeight)
                
                TextStatInfo(
                    statusTitle: "Elapsed Time",
                    pingValue: "\(Formatter.elapsedTime(viewModel.elapsedTime))"
                )
            }
            .frame(minHeight: lineHeight, alignment: .center)
            .frame(maxHeight: 80)
        }
    }
    
    @ViewBuilder
    var bottomActions: some View {
        
        HStack(spacing: 30) {
            
            VStack(alignment: .leading) {
                Text("Target Host:")
                
                HStack(alignment: .firstTextBaseline) {
                    Image(systemName: "server.rack").opacity(0.6)
                    Text("\(settings.host)")
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
                        TargetHostView()
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
                                self.viewModel.settings.objectWillChange.send()
                            }
                    }
                }
            }
            HStack {
                PlayButton(running: $viewModel.isAnalysisRunning)
                    .offset(y: 8)
                    .onTapGesture {
                        let generator = UIImpactFeedbackGenerator(style: .light)
                        generator.prepare()
                        generator.impactOccurred()
                        
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
