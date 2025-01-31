//
//  ToastMessage.swift
//  PingStats
//
//  Created by Elvis Dorow on 31/01/25.
//

import SwiftUI

struct ToastMessage: View {
    
    @State var message: LocalizedStringResource = ""
    
    var body: some View {
        HStack {
            Image(systemName: "checkmark.circle.fill")
            Text(message)
                .font(.caption)
        }
        .padding()
        .padding(.horizontal, 10)
        .background(Color.theme.accent)
        .foregroundColor(Color.white)
        .cornerRadius(10)    }
}

#Preview {
    ToastMessage(message: "Saved")
}
