//
//  StatusText.swift
//  PingStats
//
//  Created by Elvis Dorow on 15/01/25.
//

import SwiftUI

struct StatusMessage: View {
    
    @Binding var text: LocalizedStringResource
    @Binding var appState: AppState
    
    var body: some View {
        VStack {
            if appState == .paused {
                BlinkingText(text: $text)
            } else {
                Text("\(text)")
            }

        }
        .font(.footnote)
        .foregroundColor(.primary.opacity(0.6))
        .fontWeight(.regular)
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
        .padding(.horizontal)
    }
}

#Preview {
    StatusMessage(text: .constant("teste"), appState: .constant(.running))
}
