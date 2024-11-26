//
//  SessionPingLogView.swift
//  PingStats
//
//  Created by Elvis Dorow on 22/11/24.
//

import SwiftUI

struct SessionPingLogView: View {
    
    @StateObject var vm: SessionPingLogViewModel
    
    @Environment(\.presentationMode) var presentationMode

    init(session: Sessions) {
        _vm = StateObject(wrappedValue: SessionPingLogViewModel(session: session))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack {
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
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .center)
           .toolbar {
               ToolbarItem(placement: .navigationBarTrailing) {
                   Button(action: {
                       presentationMode.wrappedValue.dismiss()
                   }) {
                       Circle()
                           .fill(Color.gray.opacity(0.15))
                           .overlay {
                               Image(systemName: "xmark")
                                   .font(.system(size: 12))
                                   .fontWeight(.semibold)
                                   .foregroundColor(Color.gray.opacity(0.7))
                           }
                           .frame(width: 27)
                   }
                   .accessibilityLabel("Close")
               }
           }
        }
    }
}

#Preview {
//    SessionPingLogView()
}
