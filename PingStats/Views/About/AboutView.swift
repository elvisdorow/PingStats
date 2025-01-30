//
//  AboutView.swift
//  PingStats
//
//  Created by Elvis Dorow on 14/01/25.
//

import SwiftUI
import FirebaseAnalytics

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
            VStack(spacing: 40) {
                // App Icon
                Image("LogoAbout")
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .frame(width: 140, height: 140)
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
                    Text("Build: \(buildNumber)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }


                // Links
                VStack(spacing: 20) {
                    HStack(spacing: 5) {
                        Text("Contact Us: ")
                            
                        Link("support@pingstats.app", destination: URL(string: "mailto:support@pingstats.app?subject=Support")!)

                    }
                    Spacer()
                    
                    Link("Privacy Policy", destination: URL(string: "https://pingstats.app/privacy-policy.html")!)
                    Link("Terms of Service", destination: URL(string: "https://pingstats.app/terms-of-service.html")!)
                    Link("Visit Website", destination: URL(string: "https://pingstats.app")!)
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
            .analyticsScreen(name: "About")
        }
    }
}

#Preview("EN") {
    AboutView()
        .environment(\.locale, Locale(identifier: "EN"))
}

#Preview("PT") {
    AboutView()
        .environment(\.locale, Locale(identifier: "PT"))
}
