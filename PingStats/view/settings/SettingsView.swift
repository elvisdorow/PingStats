//
//  SettingsView.swift
//  PingStats
//
//  Created by Elvis Dorow on 09/08/24.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var settingsViewModel: SettingsViewModel

    var body: some View {
        NavigationView {
            Form{                
                Section {
                    NavigationLink(
                        destination: IPAddressesView()
                            .environmentObject(settingsViewModel)
                            .navigationTitle("Hosts")
                            .navigationBarTitleDisplayMode(.automatic),
                        label: {
                            Text("\(settingsViewModel.selectedIpAddress)")
                        })

                } header: {
                    Text("IP Address or Host Name")
                }

                Section {
                    HStack {
                        Slider(value: $settingsViewModel.pingInterval, in: 0.5...4, step: 0.5)
                        Text("\(String(format: "%0.2f", settingsViewModel.pingInterval)) sec ")
                            .frame(width: 80)
                    }
                } header: {
                    Text("Ping Interval")
                } footer: {
                    Text("Text explaining what this control does in this app")
                }

                Section {
                    HStack(spacing: 10) {
                        Slider(value: $settingsViewModel.pingSample, in: 30...200, step: 10.0)
                        Text("\(String(format: "%0.0f", settingsViewModel.pingSample))")
                            .frame(width: 50)
                    }
                } header: {
                    Text("Ping count in statistics")
                } footer: {
                    Text("The number of pings in a moving sample utilized to evaluate network performance in real-time.")
                }

                Section {
                    HStack(spacing: 10) {
                        Slider(value: $settingsViewModel.maxPingCount, in: 30...200, step: 10)
                        Text("\(String(format: "%0.0f", settingsViewModel.maxPingCount))")
                            .frame(width: 50)
                    }
                } header: {
                    Text("Stop After")
                } footer: {
                    Text("Set the maximum time the test shoud run.")
                }

                Section {
                    ForEach(Theme.allCases, id: \.self) { theme in
                        Button(action: {
                            settingsViewModel.theme = theme
                        }, label: {
                            HStack {
                                Text(theme.rawValue)
                                Spacer()
                                if settingsViewModel.theme == theme {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.accentColor)
                                }
                            }
                        })
                    }
                } header: {
                    Text("Theme")
                }

                
            }
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        settingsViewModel.objectWillChange.send()
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("OK")
                    })
                }
            }
            .preferredColorScheme(settingsViewModel.theme != .system ? (settingsViewModel.theme == .darkMode ? .dark : .light) : nil)
            .navigationTitle("Settings")
            .toolbarTitleDisplayMode(.inline)
            .foregroundColor(.primary)
        }
    }
}

#Preview {
    SettingsView().environmentObject(SettingsViewModel())
}

