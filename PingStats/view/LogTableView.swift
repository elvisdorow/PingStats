//
//  LogTableView.swift
//  PingStats
//
//  Created by Elvis Dorow on 07/08/24.
//

import SwiftUI

struct LogTableView: View {
    @Binding var logs: [LogTextModel]
    var body: some View {
        ScrollViewReader { proxy in
            
            ScrollView {
                
                ForEach(logs) { l in
                    Text(l.text)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: 7.7)
                        .foregroundColor( (l.type == .error) ? .red : .primary )
                        .fontDesign(.monospaced)
                        .font(.system(size: 10))
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
    @State static var logs: [LogTextModel] = [
        .init(type: .good, text: "1 - 12023 - 232232 2323123 332"),
        .init(type: .good, text: "1 - 12023 - 232232 2323123 332"),
        .init(type: .good, text: "1 - 12023 - 232232 2323123 332"),
        .init(type: .good, text: "1 - 12023 - 232232 2323123 332"),
        .init(type: .good, text: "1 - 12023 - 232232 2323123 332"),
        .init(type: .good, text: "1 - 12023 - 232232 2323123 332"),
        .init(type: .good, text: "1 - 12023 - 232232 2323123 332"),
        .init(type: .error, text: "1 - 12023 - 232232 2323123 332"),
        .init(type: .good, text: "1 - 12023 - 232232 2323123 332"),
        .init(type: .good, text: "1 - 12023 - 232232 2323123 332"),
        .init(type: .good, text: "1 - 12023 - 232232 2323123 332"),
        .init(type: .good, text: "1 - 12023 - 232232 2323123 332"),
        .init(type: .good, text: "1 - 12023 - 232232 2323123 332")
    ]
    
    static var previews: some View {
        LogTableView(logs: $logs)
    }
}

