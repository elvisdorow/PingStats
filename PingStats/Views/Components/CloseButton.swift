//
//  CloseButton.swift
//  PingStats
//
//  Created by Elvis Dorow on 12/12/24.
//

import SwiftUI

struct CloseButton: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "xmark")
                .font(.system(size: 14, design: .rounded))
                .opacity(0.6)
                .padding(5)
                .background(.primary.opacity(0.04))
                .clipShape(Circle())
        }
        .tint(.primary)
    }
}

struct CloseButton_Previews: PreviewProvider {
    static var previews: some View {
        CloseButton {
            print("Close button tapped")
        }
        .previewLayout(.sizeThatFits)
    }
}
