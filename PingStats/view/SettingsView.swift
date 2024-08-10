//
//  SettingsView.swift
//  PingStats
//
//  Created by Elvis Dorow on 09/08/24.
//

import SwiftUI

struct SettingsView: View {
    @State private var pingInterval: Double = 0.5
    @State private var pingSample: Double = 60
    @State private var selectedTheme: Theme = .system
    enum Theme: String, CaseIterable, Identifiable {
        case light = "Light"
        case dark = "Dark"
        case system = "System"
        
        var id: String { self.rawValue }
    }

    
    var body: some View {
        NavigationView {
            Form{
                
                Section {
                    NavigationLink(
                        destination: Text("Host manager screen"),
                        label: {
                            Text("1.1.1.1")
                        })
                } header: {
                    Text("Host Name or IP Address")
                }

                Section {
                    HStack {
                        Slider(value: $pingInterval, in: 0...1)
                        Text("\(String(format: "%0.2f", pingInterval)) sec ")
                            .frame(width: 80)
                    }
                } header: {
                    Text("Ping Interval")
                } footer: {
                    Text("Text explaining what this control does in this app")
                }

                Section {
                    HStack(spacing: 10) {
                        Slider(value: $pingSample, in: 30...200, step: 10.0)
                        Text("\(String(format: "%0.0f", pingSample))")
                            .frame(width: 50)
                    }
                } header: {
                    Text("Ping count in statistics")
                } footer: {
                    Text("The number of pings in a moving sample utilized to evaluate network performance in real-time.")
                }

                Section {
                    HStack(spacing: 10) {
                        Slider(value: $pingSample, in: 30...200, step: 10.0)
                        Text("\(String(format: "%0.0f", pingSample))")
                            .frame(width: 50)
                    }
                } header: {
                    Text("Stop After")
                } footer: {
                    Text("Set the maximum time the test shoud run.")
                }

                Section {
                    HStack {
                        Text("System")
                        Spacer()
                        Image(systemName: "checkmark")
                    }
                    HStack {
                        Text("Light")
                        Spacer()
                        Image(systemName: "")
                    }
                    HStack {
                        Text("Dark")
                        Spacer()
                        Image(systemName: "")
                    }
                } header: {
                    Text("Theme")
                }

                
            }
            .formStyle(.automatic)
            .toolbar(content: {
                ToolbarItem(placement: .automatic) {
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Text("OK")
                    })
                }

            })
            .navigationTitle("Settings")
            .toolbarTitleDisplayMode(.inline)
            .foregroundColor(.primary)

        }
    }

}

#Preview {
    SettingsView()
}
