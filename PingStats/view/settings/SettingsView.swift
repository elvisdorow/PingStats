//
//  SettingsView.swift
//  PingStats
//
//  Created by Elvis Dorow on 09/08/24.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.presentationMode) var presentationMode
       
    @StateObject var settings = Settings.shared
    
    var body: some View {
        NavigationView {
            Form{                
                Section {
                    NavigationLink(
                        destination: IPAddressesView(settings: settings)
                            .navigationTitle("Hosts")
                            .navigationBarTitleDisplayMode(.automatic),
                        label: {
                            Text("\(settings.selectedIpAddress)")
                        })

                } header: {
                    Text("IP Address or Host Name")
                }

                Section {
                    PingTimeoutSlider(pingTimeout: $settings.pingTimeout)
                } header: {
                    Text("Ping Timeout")
                } footer: {
                    Text("Maximum time to wait for a ping response before timing out.")
                }

                Section {
                    PingIntervalSlider(intervalValue: $settings.pingInterval)
                    
                } header: {
                    Text("Ping Interval")
                } footer: {
                    Text("Interval between consecutive ping requests.")
                }

                Section {
                    PingCountStatSlider(countStat: $settings.pingCountStat)
                } header: {
                    Text("Ping count in statistics")
                } footer: {
                    Text("The number of pings in a moving sample utilized to evaluate network performance in real-time.")
                }

                Section {
                    
                    PingMaxtimeSlider(maxtime: $settings.maxtimeSetting)
       
                } header: {
                    Text("Stop After")
                } footer: {
                    Text("Maximum duration for the test to run before it stops automatically.")
                }

                Section {
                    ForEach(Theme.allCases, id: \.self) { theme in
                        Button(action: {
                            settings.theme = theme
                            
                        }, label: {
                            HStack {
                                Text("\(theme.name)")
                                Spacer()
                                if settings.theme == theme {
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
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("OK")
                    })
                }
            }
            .navigationTitle("Settings")
            .toolbarTitleDisplayMode(.inline)
        }
    }
}


#Preview {
    SettingsView()
}

