//
//  AboutView.swift
//  PingStats
//
//  Created by Elvis Dorow on 14/01/25.
//

import SwiftUI
import RevenueCat
import RevenueCatUI
import FirebaseAnalytics

struct AboutView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userViewModel: UserViewModel
    
    @State private var showPaywall: Bool = false
    
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
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal)
                
                
                if userViewModel.isPayingUser {
                    proUserView
                } else {
                    freeUserView
                }
                
                // Links
                VStack(spacing: 20) {
                    HStack(spacing: 5) {
                        Link("support@pingstats.app", destination: URL(string: "mailto:support@pingstats.app?subject=Support")!)
                        
                    }
                    
                    versionView
                    
                    Spacer()
                    
                    HStack(spacing: 15) {
                        Link("Privacy Policy", destination: URL(string: "https://pingstats.app/privacy-policy.html")!)
                        Link("Terms of Service", destination: URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!)
                    }
                    .font(.footnote)
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
            .sheet(isPresented: $showPaywall, content: {
                PaywallView()
            })
            .analyticsScreen(name: "About")
        }
    }
    
    var proUserView: some View {
        VStack(spacing: 10) {
            Text("Thank You for Your Support! 🎉")
                .font(.headline)
                .multilineTextAlignment(.center)
            
            Text("You're a Pro user!")
                .font(.subheadline)
                .lineLimit(3)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
        }
        .padding()
    }
    
    var freeUserView: some View {
        VStack(spacing: 15) {
            Text("Unlock Pro Features 🚀")
                .font(.headline)
                .multilineTextAlignment(.center)
            
            Button(action: {
                showPaywall = true
            }) {
                Text("Upgrade to Pro")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.theme.accent)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
        }
    }
    
    var versionView: some View {
        // Version Information
        HStack(spacing: 3) {
            Text("Version: \(appVersion)")
                .font(.subheadline)
            
            Text("(\(buildNumber))")
                .font(.subheadline)
        }
        .foregroundColor(.secondary)
    }
}

#Preview("EN") {
    AboutView()
        .environment(\.locale, Locale(identifier: "EN"))
        .environmentObject(UserViewModel())
}

#Preview("PT") {
    AboutView()
        .environment(\.locale, Locale(identifier: "PT"))
        .environmentObject(UserViewModel())
}
