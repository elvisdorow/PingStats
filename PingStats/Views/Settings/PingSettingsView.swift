//
//  IPSettingsView.swift
//  PingStats
//
//  Created by Elvis Dorow on 09/10/24.
//

import SwiftUI
import FirebaseAnalytics
import RevenueCatUI

struct PingSettingsView: View {
    
    @StateObject var settings = Settings.shared
    @EnvironmentObject var userViewModel: UserViewModel
    @State var showPaywall: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    PingTimeoutSlider(pingTimeout: $settings.pingTimeout)
                } header: {
                    Text("Timeout")
                } footer: {
                    Text("Maximum time to wait for a ping response before timing out.")
                }

                Section {
                    PingIntervalSlider(intervalValue: $settings.pingInterval, enabled: $userViewModel.isPayingUser)
                    
                } header: {
                    HStack {
                        Text("Interval")
                        if !userViewModel.isPayingUser {
                            Spacer()
                            ProBadge()
                        }
                    }
                } footer: {
                    Text("Interval between consecutive ping requests.")
                }
                .gesture(
                    userViewModel.isPayingUser ? nil : DragGesture().onChanged { _ in
                        showPaywall = true
                    }
                )
                .onTapGesture {
                    if !userViewModel.isPayingUser {
                        showPaywall.toggle()
                    }
                }

                
                Section {
                    PingPayloadSlider(payload: $settings.pingPayload, enabled: $userViewModel.isPayingUser)
                } header: {
                    HStack {
                        Text("Payload Size")
                        if !userViewModel.isPayingUser {
                            Spacer()
                            ProBadge()
                        }
                    }
                }
                .gesture(
                    userViewModel.isPayingUser ? nil : DragGesture().onChanged { _ in
                        showPaywall = true
                    }
                )
                .onTapGesture {
                    if !userViewModel.isPayingUser {
                        showPaywall.toggle()
                    }
                }


                Section {
                    PingCountStatSlider(countStat: $settings.pingCountStat)
                } header: {
                    Text("Ping count in statistics")
                } footer: {
                    Text("The number of pings in a moving sample utilized to evaluate network performance in real-time.")
                }
                
                Button {
                    resetToDefaults()
                    
                } label: {
                    Text("Reset to defaults")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .frame(height: 40)
                }
                .buttonStyle(.borderless)

            }
            .tint(.theme.accent)
        }
        .tint(.primary)
        .sheet(isPresented: $showPaywall, content: {
            PaywallView()
        })
        .analyticsScreen(name: "Ping Settings")
    }
    
    func resetToDefaults() {
        settings.pingInterval = .sec1
        settings.pingCountStat = .count50
        settings.maxtimeSetting = .min5
        settings.pingTimeout = .sec2
        settings.pingPayload = .bytes64
    }
}

#Preview {
    PingSettingsView().environmentObject(UserViewModel())
}
