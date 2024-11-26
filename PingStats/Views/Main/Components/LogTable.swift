//
//  LogTableView.swift
//  PingStats
//
//  Created by Elvis Dorow on 07/08/24.
//

import SwiftUI

struct LogTable: View {
    
    @Binding var logs: [PingLog]
    
    var body: some View {
        ScrollViewReader { proxy in
            
            ScrollView {
                
                ForEach(logs) { l in
                    
                    Text("\(l.bytes) bytes icmp_seq=\(l.sequence) ttl=\(l.timeToLive) time=\(l.duration.pingDurationFormat()) ms")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                        .foregroundColor( (l.error != nil) ? .red : .primary )
                        .fontDesign(.monospaced)
                        .font(.caption2)
                        .id(l.id)
                }
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            .padding(7)
            .padding(.horizontal)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(.systemGray5), lineWidth: 1) // Border color and width
            )
            .onChange(of: logs) {
                // Scroll to the last item when the view appears
                if let lastItem = logs.last {
                    proxy.scrollTo(lastItem.id)
                }
            }

        }
    }
}

struct LogTableViewPreview: PreviewProvider {
    @State static var logs: [PingLog] = [
 
    ]
    
    static var previews: some View {
        LogTable(logs: $logs)
    }
}

