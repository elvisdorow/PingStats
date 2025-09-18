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
    
    var logoSize: CGFloat {
        UIScreen.main.bounds.width * 0.26
    }
    
    var mainSpacing: CGFloat {
        UIScreen.main.bounds.height * 0.04
    }
        
    var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }
    
    var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }
    
    var body: some View {
        NavigationView {
                VStack(spacing: mainSpacing) {
                    
                    logoHeaderView
                    
                    Spacer()
                    
                    if userViewModel.isPayingUser {
                        proUserView
                    } else {
                        freeUserView
                    }
                    
                    // Links
                    reviewButtonView
                            
                    Spacer()
                    
                    Button(action: {
                        UIApplication.shared.open(URL(string: "mailto:support@pingstats.app?subject=Support")!)
                    }) {
                        HStack(spacing: 5) {
                            Image(systemName: "envelope.fill")
                            Text("support@pingstats.app")
                        }
                    }

                    
                    HStack(spacing: 15) {
                        Link("Privacy Policy", destination: URL(string: "https://pingstats.app/privacy-policy.html")!)
                        Link("Terms of Service", destination: URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!)
                    }
                    .font(.footnote)
                    
                    versionView
                        
                    .font(.body)
                    .padding(.bottom, 35)

            }
            .navigationTitle("About PingStats")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("OK") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.primary)
                }
            }
            .sheet(isPresented: $showPaywall, content: {
                PaywallView()
            })
            .analyticsScreen(name: "About")
        }
    }
    
    var logoHeaderView: some View {
        VStack(spacing: 15) {
            // App Icon
            Image("LogoAbout")
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .frame(width: logoSize, height: logoSize)
                .foregroundColor(.blue)
                .padding(.top, 30)
            
            // App Title
            Text("PingStats")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)
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
    
    var reviewButtonView: some View {
        VStack(spacing: 15) {
            Button(action: {
                UIApplication.shared.open(URL(string: "https://apps.apple.com/app/6741027710")!)
            }) {
                VStack(spacing: 10) {
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                        Image(systemName: "star.fill")
                        Image(systemName: "star.fill")
                        Image(systemName: "star.fill")
                        Image(systemName: "star.fill")
                    }
                    .font(.subheadline)
                    .foregroundColor(.yellow)
                    
                    Text("Review us on the App Store")
                }
            }
        }
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
            .padding(.horizontal, 30)
        }
    }
    
    var versionView: some View {
        // Version Information
        HStack(spacing: 3) {
            Image(systemName: "info.circle")
                .font(.footnote)
            Text("\(appVersion)")
                .font(.footnote)
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
