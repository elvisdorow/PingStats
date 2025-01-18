//
//  AlertPauseBgView.swift
//  PingStats
//
//  Created by Elvis Dorow on 17/01/25.
//

import SwiftUI

struct AlertPauseBgView: View {

    let completion: ()-> Void
    
    init(completion: @escaping ()-> Void) {
        self.completion = completion
    }
    
    var body: some View {
                
        VStack {
            VStack(alignment: .leading, spacing: 20, content: {
                
                Label {
                    Text("Test Paused")
                } icon: {
                    Image(systemName: "pause.fill")
                }
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

                
                Text("The test has been paused because the app was moved to the background. The test will only run while the app is active in the foreground.")
                
                VStack {
                    Button {
                        completion()
                        
                    } label: {
                        Label {
                            Text("Understood")
                        } icon: {
                            Image(systemName: "hand.thumbsup.fill")
                        }
                        .padding(.horizontal, 15)
                        .padding(.vertical, 7)

                    }
                    .buttonStyle(.borderedProminent)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 5)

            })
        }
        .padding(.horizontal, 20)
        
        .frame(width: 340, height: 300, alignment: .center)
        .background {
            Color.theme.backgroundTop
        }
        .cornerRadius(18)
    }
}

#Preview("PT") {
    ZStack {
        Color.gray.opacity(0.5)
        
        
        AlertPauseBgView {
            print("alert pause bg")
        }
        .environment(\.locale, .init(identifier: "pt"))

    }
    .ignoresSafeArea()
}

#Preview("EN") {
    ZStack {
        Color.gray.opacity(0.5)
        
        
        AlertPauseBgView {
            print("alert pause bg")
        }
        .environment(\.locale, .init(identifier: "en"))
    }
    .ignoresSafeArea()
}
