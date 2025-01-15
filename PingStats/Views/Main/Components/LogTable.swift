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
                LazyVStack(alignment: .leading, spacing: 0) {
                    ForEach(logs) { log in
                        LogRow(log: log)
                            .id(log.id)
                    }
                }
            }
            .padding(.horizontal)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(.systemGray5), lineWidth: 1)
            )
            .onChange(of: logs) { _, _ in
                if let lastItem = logs.last {
                    proxy.scrollTo(lastItem.id)
                }
            }
        }
    }
}

struct LogRow: View {
    let log: PingLog

    var body: some View {
        Group {
            if let error = log.error {
                Text(error)
                    .foregroundColor(.red)
            } else {
                Text("\(log.bytes) bytes icmp_seq=\(log.sequence) ttl=\(log.timeToLive) time=\(log.duration.pingDurationFormat()) ms")
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(.system(size: 12, design: .monospaced))
        .padding(.vertical, 3)
    }
}

struct LogTableViewPreview: PreviewProvider {
    @State static var logs: [PingLog] = []

    static var previews: some View {
        LogTable(logs: $logs)
    }
}


