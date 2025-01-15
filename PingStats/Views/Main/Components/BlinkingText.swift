//
//  BlinkingText.swift
//  PingStats
//
//  Created by Elvis Dorow on 15/01/25.
//

import SwiftUI

struct BlinkingText: View {
    
    @Binding var text: LocalizedStringResource
    @State private var isVisible = true
    @State private var timer: Timer? = nil
    
    var body: some View {
        Text(text)
            .opacity(isVisible ? 1 : 0)
            .onAppear {
                startBlinking()
            }
            .onDisappear {
                stopBlinking()
            }
    }
    
    private func startBlinking() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true) { _ in
            isVisible.toggle()
        }
    }
    
    private func stopBlinking() {
        timer?.invalidate()
        timer = nil
    }
}

#Preview {
    BlinkingText(text: .constant("Teste pausado..."))
}
