//
//  SessionPingLogView.swift
//  PingStats
//
//  Created by Elvis Dorow on 22/11/24.
//

import SwiftUI

struct SessionPingLogView: View {
    
    let session: Sessions
    
    var body: some View {
        Text("\(session.logs?.count ?? 0)")
        ScrollView {
            if let logs = session.logs {
                let logsArray = logs.compactMap { $0 as? PingLog }
                
                ForEach(logsArray, id: \.self) { l in
                    
                    Text("\(l.bytes) bytes icmp_seq=\(l.sequence) ttl=\(l.timeToLive) time=\(l.duration.pingDurationFormat())ms")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                        .foregroundColor( (l.error != nil) ? .red : .primary )
                        .fontDesign(.monospaced)
                        .font(.caption2)
                        .id(l.id)
                }

            }
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        .padding(7)
        .padding(.horizontal)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.systemGray5), lineWidth: 1) // Border color and width
        )
    }
}

#Preview {
//    SessionPingLogView()
}
