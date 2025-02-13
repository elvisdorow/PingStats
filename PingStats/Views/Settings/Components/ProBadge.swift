//
//  ProBadge.swift
//  PingStats
//
//  Created by Elvis Dorow on 13/02/25.
//

import SwiftUI

struct ProBadge: View {
    var body: some View {
        HStack(spacing: 3) {
            Image(systemName: AppIcon.proIcon)
            Text("Pro")
        }
    }
}

#Preview {
    ProBadge()
}
