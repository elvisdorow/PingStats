//
//  AboutView.swift
//  PingStats
//
//  Created by Elvis Dorow on 14/01/25.
//

import SwiftUI

struct AboutView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }
    
    var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // App Icon
                Image(systemName: "wifi")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)
                    .padding(.top, 40)

                // App Title
                Text("PingStats")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)

                // App Description
                Text("PingStat is a network monitoring app that helps you analyze network performance by providing detailed latency statistics, jitter analysis, and packet loss measurements.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                // Version Information
                VStack(spacing: 5) {
                    Text("Version: \(appVersion)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Spacer()

                // Links
                VStack(spacing: 15) {
                    Link("Privacy Policy", destination: URL(string: "https://yourwebsite.com/privacy-policy")!)
                    Link("Terms of Service", destination: URL(string: "https://yourwebsite.com/terms-of-service")!)
                    Link("Visit Website", destination: URL(string: "https://yourwebsite.com")!)
                }
                .font(.body)
                .padding(.bottom, 40)
            }
            .navigationTitle("About PingStats")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("OK") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}
