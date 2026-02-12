//
//  ContentView.swift
//  PingStats
//
//  Created by Elvis Dorow on 15/07/24.
//

import SwiftUI
import Charts
import FullscreenPopup
import FirebaseAnalytics
import SimpleToast
import RevenueCatUI
import StoreKit

struct MainView: View {
    
    @State private var selectedSegment = 1
    @State private var showLogs = false
    
    @State private var showSettingsView: Bool = false
    @State private var showResultsView: Bool = false
    @State private var showAboutView: Bool = false
    
    @State private var showHostList: Bool = false
    @State private var showAlertPausedBg: Bool = false
    @State private var showShareSheet: Bool = false
    @State private var showSaveConfirmation: Bool = false
    
    @State private var showPaywall: Bool = false
        
    private let toastOptions = SimpleToastOptions(
        hideAfter: 3
    )
    
    @StateObject var viewModel: MainViewModel = MainViewModel()
    @StateObject var settings = Settings.shared
    
    @Environment(\.scenePhase) var scenePhase
    
    @Environment(\.requestReview) var requestReview

    @EnvironmentObject var userViewModel: UserViewModel

    var body: some View {
        NavigationStack {
            
            ZStack {
                RadialGradient(gradient: Gradient(colors: [Color.theme.backgroundTop, Color.theme.backgroundBottom]),
                               center: .topLeading,
                               startRadius: 0,
                               endRadius: 900).ignoresSafeArea()
                
                VStack(spacing: 0) {
                    
                    chartLogView
                    
                    horizontalChartNetQualityView

                    gaugesView
                    
                    textStatsView
                    
                    bottomActions
                }
                .toolbar(content: {
                                            
                    if #available(iOS 26.0, *) {
                        ToolbarItem(placement: .topBarLeading) {
                            HStack {
                                Image("logo")
                            }
                        }
                        .sharedBackgroundVisibility(.hidden)
                    } else {
                        ToolbarItem(placement: .topBarLeading) {
                            HStack {
                                Image("logo")
                            }
                        }
                    }

                    ToolbarItem(placement: .topBarTrailing) {
                        menuItems
                    }
                        
                })
                .popup(isPresented: $showAlertPausedBg, delay: .seconds(1)) { isPresented in
                    Color.gray.opacity(0.5)
                } content: {
                    AlertPauseBgView {
                        showAlertPausedBg = false
                        viewModel.isMessageBgPausedShown = true
                    }
                }
                .environmentObject(viewModel)
                .accentColor(Color.theme.accent)
            }
            .popover(isPresented: $showSettingsView) {
                SettingsView()
                    .presentationCompactAdaptation(.fullScreenCover)
            }
            .popover(isPresented: $showResultsView) {
                SessionsListView()
                    .presentationCompactAdaptation(.fullScreenCover)
            }
            .popover(isPresented: $showAboutView) {
                AboutView()
                    .presentationCompactAdaptation(.automatic)
            }
            .popover(isPresented: $showPaywall) {
                PaywallView()
                    .presentationCompactAdaptation(.fullScreenCover)
            }
            .sheet(isPresented: $showShareSheet) {
                ActivityView(activityItems: [viewModel.fileURL!as Any])
            }
            .simpleToast(isPresented: $showSaveConfirmation, options: toastOptions) {
                ToastMessage(message: "Result saved in files.")
            }

            
        }
        .onChange(of: scenePhase) { _, newValue in
            if newValue == .background && viewModel.isAnalysisRunning {
                viewModel.pause()
                
                if !viewModel.isMessageBgPausedShown {
                    NotificationService.instance.sendAppInBackgroundNotification { scheduled in
                        if scheduled {
                            print("Notification scheduled")
                        }
                    }
                }
            }
            
            if newValue == .active && viewModel.appState == .paused {
                if viewModel.isMessageBgPausedShown == false {
                    showAlertPausedBg = true
                }
            }            
        }
        .onChange(of: settings.host, { oldValue, newValue in
            if viewModel.appState == .stopped
                || viewModel.appState == .empty {

                viewModel.hostTextBox = settings.host
            }
        })
        .onChange(of: viewModel.shouldShowReview, { _, newValue in
            if newValue {
                requestReview()
                viewModel.shouldShowReview = false
            }
        })
        .analyticsScreen(name: "MainView")
    }
}

// MARK: Extensions

extension MainView {
    
    @ViewBuilder
    var menuItems: some View {
        Menu {
            Button(action: {
                if userViewModel.isPayingUser {
                    showResultsView.toggle()
                } else {
                    showPaywall.toggle()
                }
            },
                   label: {

                Label(
                    title: {
                        Text("Results")
                    },
                    icon: { Image(systemName: userViewModel.isPayingUser ? "list.bullet.rectangle.portrait" : AppIcon.proIcon) }
                )
            })

            if viewModel.session != nil && viewModel.appState == .stopped {
                // share session button
                Button(action: {
                    if userViewModel.isPayingUser {
                        viewModel.saveSessionToFile()
                        if viewModel.fileURL != nil {
                            showShareSheet.toggle()
                        }
                    } else {
                        showPaywall.toggle()
                    }
                },
                    label: {
                    Label(
                        title: {
                            Text("Share")
                        },
                        icon: { Image(systemName: userViewModel.isPayingUser ? "square.and.arrow.up" : AppIcon.proIcon) }
                    )
                })
                
                // save session button
                Button(action: {
                    if userViewModel.isPayingUser {
                        viewModel.saveSessionToFile()
                        if viewModel.fileURL != nil {
                            showSaveConfirmation.toggle()
                        }
                    } else {
                        showPaywall.toggle()
                    }
                    
                },
                    label: {
                    Label(
                        title: {
                            Text("Save in Files")
                        },
                        icon: { Image(systemName: userViewModel.isPayingUser ? "square.and.arrow.down" : AppIcon.proIcon) }
                    )
                })

            }
            
            
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
                showAboutView.toggle()
            },
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
        .tint(.primary)
    }
    
    @ViewBuilder
    var chartLogView: some View {
        SegmentedControl2(selected: $viewModel.chartType, width: 230)
            .padding(.top, 15)
            .padding(.leading, 10)
        
        ChartLogView()
            .frame(minHeight: UIScreen.main.bounds.height * 0.14)
            .padding(.horizontal)
            .padding(.bottom)
        
        if viewModel.hasNetworkError {
            Text("Network error ⚠️")
                .font(.footnote)
                .foregroundColor(.red)
                .fontWeight(.semibold)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                .padding(.horizontal)

        } else {
            StatusMessage(text: $viewModel.statusMessage, appState: $viewModel.appState)
        }
    }
    
    @ViewBuilder
    var horizontalChartNetQualityView: some View {
        
        let screenHeight = UIScreen.main.bounds.height
        let barHeight = screenHeight * 0.0224
        
        VStack(alignment: .leading, spacing: 7) {
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
                        .frame(height: barHeight)
                }
                Text("\(Formatter.number(viewModel.pingStat.generalScore, fraction: 0, unit: "%"))")
                    .frame(width: 57)
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
        .padding(.horizontal)
        .padding(.top, 6)
    }
    
    @ViewBuilder
    var textStatsView: some View {
        
        let screenHeight = UIScreen.main.bounds.height
        
        let verticalDividerHeight = screenHeight * 0.05
        let verticalSpacing = screenHeight * 0.04
        
        HStack(alignment: .center , spacing: 0) {
            
            VStack(spacing: verticalSpacing) {
                TextStatInfo(
                    statusTitle: "Worst",
                    pingValue: "\(Formatter.number(viewModel.pingStat.worstPing, fraction: 0, unit: "ms"))"
                )

                TextStatInfo(
                    statusTitle: "Package Loss",
                    pingValue: "\(Formatter.number(viewModel.pingStat.packageLoss, fraction: 1, unit: "%"))")
                
            }
            VStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.15))
                    .frame(width: 1, height: verticalDividerHeight)
                          
            }
            VStack(alignment: .leading, spacing: verticalSpacing) {
                TextStatInfo(
                    statusTitle: "Average",
                    pingValue: "\(Formatter.number(viewModel.pingStat.averagePing, fraction: 0, unit: "ms"))",
                    fontSize: 30,
                    fontWeight: .regular
                )
                TextStatInfo(
                    statusTitle: "Jitter",
                    pingValue: "\(Formatter.number(viewModel.pingStat.jitter, fraction: 0, unit: "ms"))")
            }
            .frame(
                maxHeight: .infinity
            )
            
            VStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.15))
                    .frame(width: 1, height: verticalDividerHeight)
                          
            	}
            VStack(spacing: verticalSpacing) {
                TextStatInfo(
                    statusTitle: "Best",
                    pingValue: "\(Formatter.number(viewModel.pingStat.bestPing, fraction: 0, unit: "ms"))"
                )
            
                TextStatInfo(
                    statusTitle: "Elapsed Time",
                    pingValue: "\(Formatter.elapsedTime(viewModel.elapsedTime))"
                )
            }
        }
        .frame(maxHeight: 180)
        .padding(.horizontal, 5)
    }
    
    @ViewBuilder
    var bottomActions: some View {
        
        HStack(alignment:.center, spacing: 30) {
            
            VStack(alignment: .leading) {
                HStack(alignment: .firstTextBaseline) {
                    HStack(spacing: 3) {
                        Image(systemName: "server.rack")
                            .opacity(0.6)
                        Text("Target Host")
                            .opacity(0.6)
                            .font(.subheadline)
                            .lineLimit(1)
                    }
                    .fixedSize(
                        horizontal: true,
                        vertical: true
                    )
                    Text("\(viewModel.hostTextBox)")
                        .foregroundColor(viewModel.isAnalysisRunning ? .primary.opacity(0.8) : .primary)
                        .lineLimit(1)
                        .font(.subheadline)

                        
                }
                .padding(.leading, 8)
                .padding(.trailing, 8)
                .frame(height: 40)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                .background(viewModel.isAnalysisRunning ? Color(.systemGray4).opacity(0.36): Color(.systemGray4))
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
                                    if #available(iOS 26.0, *) {
                                        Button(action: {
                                            showHostList = false
                                        }, label: {
                                            Image(systemName: "xmark")
                                        })
                                        .foregroundColor(.primary)
                                    } else {
                                        CloseButton {
                                            showHostList = false
                                        }
                                    }
                                }
                            })
                            .onAppear {
                                self.viewModel.settings.objectWillChange.send()
                            }
                    }
                }
            }
            VStack(spacing: 10) {
                PlayButton(appState: viewModel.appState)
                    .offset(y: 8)
                    .onTapGesture {
                        switch viewModel.appState {
                        case .empty, .stopped:
                            viewModel.start()
                        case .paused:
                            viewModel.resume()
                        case .running:
                            viewModel.stop()
                        }
                        triggerHaptic(style: .medium)
                    }
                    .onLongPressGesture {
                        if viewModel.appState == .paused {
                            viewModel.stop()
                            triggerHaptic(style: .medium)
                        }
                        
                        if viewModel.appState == .running {
                            viewModel.pause()
                            triggerHaptic(style: .medium)
                        }
                    }
                
                Text("\(viewModel.actionButtonTitle)")
                    .font(.caption)
                    .foregroundColor(.primary.opacity(0.8))
                    .padding(.top, 5)
            }
        }
        .padding(.vertical, 5)
        .padding(.horizontal)
        .frame(maxWidth: .infinity)
    }

    func triggerHaptic(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }

}


#Preview {
    MainView().environmentObject(UserViewModel())
}

#Preview {
    MainView().environmentObject(UserViewModel()).preferredColorScheme(.dark)
}

#Preview("EN") {
    MainView()
        .environmentObject(UserViewModel())
        .environment(\.locale, Locale(identifier: "EN"))
}
