//
//  SessionPingLogView.swift
//  PingStats
//
//  Created by Elvis Dorow on 22/11/24.
//

import SwiftUI
import FirebaseAnalytics

struct SessionPingLogView: View {
    
    @StateObject var vm: SessionPingLogViewModel
    
    @Environment(\.presentationMode) var presentationMode

    init(session: Sessions) {
        _vm = StateObject(wrappedValue: SessionPingLogViewModel(session: session))
    }
    
    var body: some View {
        NavigationView {
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        ForEach(vm.logs, id: \.self) { l in
                            if let error = l.error {
                                Text("\(l.bytes) bytes icmp_seq=\(l.sequence) \(error)")
                                    .frame(maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                                    .foregroundColor(.red)
                                    .fontDesign(.monospaced)
                                    .font(.caption)
                                    .id(l.id)
                            } else {
                                Text("\(l.bytes) bytes icmp_seq=\(l.sequence) ttl=\(l.timeToLive) time=\(l.duration.pingDurationFormat()) ms")
                                    .frame(maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                                    .fontDesign(.monospaced)
                                    .font(.caption)
                                    .id(l.id)
                            }
                        }
                    }
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .center)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .center)
           .toolbar {
               ToolbarItem(placement: .navigationBarLeading) {
                   CloseButton {
                       presentationMode.wrappedValue.dismiss()
                   }
               }
           }
           .analyticsScreen(name: "Session Ping Logs")
        }
    }
}

#Preview {
//    SessionPingLogView()
}
