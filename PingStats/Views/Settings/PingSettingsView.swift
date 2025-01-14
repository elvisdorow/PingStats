//
//  IPSettingsView.swift
//  PingStats
//
//  Created by Elvis Dorow on 09/10/24.
//

import SwiftUI

struct PingSettingsView: View {
    
    @StateObject var settings = Settings.shared
    
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
                    PingIntervalSlider(intervalValue: $settings.pingInterval)
                    
                } header: {
                    Text("Interval")
                } footer: {
                    Text("Interval between consecutive ping requests.")
                }
                
                Section {
                    PingPayloadSlider(payload: $settings.pingPayload)
                } header: {
                    Text("Payload Size")
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
    PingSettingsView()
}
