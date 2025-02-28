//
//  SettingsView.swift
//  PingStats
//
//  Created by Elvis Dorow on 09/08/24.
//

import SwiftUI
import FirebaseAnalytics
import RevenueCatUI

struct SettingsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userViewModel: UserViewModel
    @State var showPaywall: Bool = false
    @StateObject var settings = Settings.shared
    
    var body: some View {
        
        NavigationStack {
            List {
                Section {
                    NavigationLink(
                        destination: TargetHostView(settings: settings)
                            .navigationTitle("Hosts")
                            .navigationBarTitleDisplayMode(.automatic),
                        label: {
                            Label {
                                Text("\(settings.host)")
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
                            .navigationTitle("Ping Configuration")
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
                    PingMaxtimeSlider(maxtime: $settings.maxtimeSetting, enabled: $userViewModel.isPayingUser)
       
                } header: {
                    HStack {
                        Text("Stop After")
                        if !userViewModel.isPayingUser {
                            Spacer()
                            ProBadge()
                        }
                    }
                } footer: {
                    Text("Maximum duration for the test to run before it stops automatically.")
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
                    ForEach(Theme.allCases) { theme in
                        ThemeButton(theme: theme, selected: settings.theme == theme)
                    }
                } header: {
                    Text("Theme")
                }

            }
            .sheet(isPresented: $showPaywall, content: {
                PaywallView()
            })
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
            .navigationBarTitleDisplayMode(.inline)
            .analyticsScreen(name: "Settings")
            
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
                            .foregroundColor(Color.theme.accent)
                    }
                }
            })
            .foregroundColor(.primary)
        }

    }
}

struct SettingsView_Preview: PreviewProvider {
    static var previews: some View {
        let userViewModel = UserViewModel()
        userViewModel.isPayingUser = true
        
        return SettingsView().environmentObject(userViewModel)
    }
}

