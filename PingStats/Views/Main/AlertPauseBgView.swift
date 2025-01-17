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
                    Text("Warning")
                } icon: {
                    Image(systemName: "eye.slash")
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
                        .padding(.horizontal)
                        .padding(.vertical, 7)

                    }
                    .buttonStyle(.borderedProminent)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()

            })
            .frame(alignment: .leading)
        }
        .padding()
        
        .frame(width: 340, height: 300)
        .background {
            Color.theme.backgroundTop
        }
        .cornerRadius(18)
    }
}

#Preview {
    AlertPauseBgView {
        print("alert pause bg")
    }
}
