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
            List {
                Section {
                    NavigationLink(
                        destination: IPAddressesView(settings: settings)
                            .navigationTitle("Hosts")
                            .navigationBarTitleDisplayMode(.automatic),
                        label: {
                            Label {
                                Text("\(settings.selectedIpAddress)")
                            } icon: {
                                Image(systemName: "server.rack").opacity(0.6)
                            }
                        }).foregroundColor(.primary)

                } header: {
                    Text("IP Address or Host Name")
                }

                Section {
                    NavigationLink(
                        destination: PingSettingsView()
                            .navigationTitle("Ping Settings")
                            .navigationBarTitleDisplayMode(.automatic),

                        label: {
                            Label {
                                Text("Ping Configuration")
                            } icon: {
                                Image(systemName: "slider.horizontal.3").opacity(0.6)
                            }
                        }).foregroundColor(.primary)

                }
                

                Section {
                    PingMaxtimeSlider(maxtime: $settings.maxtimeSetting)
       
                } header: {
                    Text("Stop After")
                } footer: {
                    Text("Maximum duration for the test to run before it stops automatically.")
                }

                Section {

                    ForEach(Theme.allCases) { theme in
                        ThemeButton(theme: theme, selected: settings.theme == theme)
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

struct ThemeButton: View {
    var theme: Theme
    var selected: Bool
    var settings: Settings = .shared
    
    var body: some View {
        HStack {
            theme.icon
            Button(action: {
                settings.theme = theme
            }, label: {
                HStack {
                    Text("\(theme.name)")
                    Spacer()
                    if selected {
                        Image(systemName: "checkmark")
                            .foregroundColor(.accentColor)
                    }
                }
            })
            .foregroundColor(.primary)
        }

    }
}

#Preview {
    SettingsView()
}

