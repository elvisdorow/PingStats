//
//  BottomButtonStyle.swift
//  PingStats
//
//  Created by Elvis Dorow on 02/01/25.
//

import SwiftUI

struct IconAndTitleButton: View {
    let title: LocalizedStringResource
    let systemImage: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: systemImage)
                    .font(.callout)
                Text(title)
                    .font(.callout)
            }
        }
        .foregroundColor(.primary)
        .tint(.primary)
    }
}
