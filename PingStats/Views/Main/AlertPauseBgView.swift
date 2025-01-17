//
//  AlertPauseBgView.swift
//  PingStats
//
//  Created by Elvis Dorow on 17/01/25.
//

import SwiftUI

struct AlertPauseBgView: View {
    var body: some View {
        ZStack {
            Color.gray.opacity(0.7)
            VStack(spacing: 20) {
                
                HStack {
                    Image(systemName: "eye.slash")         .font(.largeTitle)
                        .foregroundColor(.secondary)
                    
                    VStack(alignment: .leading, spacing: 30, content: {
                        Text("Warning")
                            .font(.headline)
                        
                        Text("The test has been paused because the app was moved to the background. The test will only run while the app is active in the foreground.")
                            .font(.body)
                        
                        Button {
                            
                            
                        } label: {
                            Label {
                                Text("Understood")
                            } icon: {
                                Image(systemName: "hand.thumbsup.fill")
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 7)

                        }
                        .buttonStyle(.borderedProminent)

                    })
                    .frame(alignment: .leading)
                }
                
            }
            .padding()
            
            .frame(width: 340, height: 330)
            .background {
                Color.theme.backgroundTop
            }
            .cornerRadius(18)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    AlertPauseBgView()
}
