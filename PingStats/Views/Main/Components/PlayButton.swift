//
//  PlayButtonView.swift
//  PingStats
//
//  Created by Elvis Dorow on 24/07/24.
//

import SwiftUI

struct PlayButton: View {
    
    var appState: AppState

    var body: some View {
        switch appState {
        case .empty, .stopped:
            ButtomImageView(buttonImage: "play.fill")
        case .running:
            ButtomImageView(buttonImage: "stop.fill")
        case .paused:
            ChangeIconButtonImage()
        }
    }
}


struct ButtomImageView: View {
    
    var buttonImage: String
    
    var body: some View {
        circleView()
            .overlay(alignment: .center) {
                iconButtonView(buttonImage: buttonImage)
            }
    }
}

struct ChangeIconButtonImage: View {
    private let buttonImages: [String] = ["play.fill", "pause.fill"]
    
    @State private var buttonImageIndex: Int = 0
    @State private var timer: Timer? = nil
    
    var body: some View {
        circleView()
            .overlay(alignment: .center) {
                iconButtonView(buttonImage: buttonImages[buttonImageIndex])
            }
            .onAppear {
                startToggleButtonImage()
            }
            .onDisappear {
                stopToggleButtonImage()
            }
    }
    
    private func startToggleButtonImage() {
        // Create and schedule the timer
        timer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true) { _ in
            buttonImageIndex = (buttonImageIndex + 1) % buttonImages.count
        }
    }
    
    private func stopToggleButtonImage() {
        // Invalidate and nil the timer
        timer?.invalidate()
        timer = nil
    }
}

struct circleView: View {
    var body: some View {
        Circle()
            .fill(.accent.gradient)
            .frame(width: 60, height: 60)
            .shadow(radius: 4, x: 2, y: 4)
    }
}

struct iconButtonView: View {
    var buttonImage: String
    
    var body: some View {
        Image(systemName: buttonImage)
            .resizable()
            .scaledToFit()
            .foregroundColor(Color(.white))
            .frame(width: 25, height: 25)
            .offset(x: buttonImage == "play.fill" ? 2.0 : 0)
    }
}



#Preview {
    PlayButton(appState: .stopped)
}
