//
//  ResultListView.swift
//  PingStats
//
//  Created by Elvis Dorow on 11/09/24.
//

import SwiftUI

struct SessionsListView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var vm = SessionListViewModel()
    
    var body: some View {
        NavigationView {            
            List {
                if vm.sessions.isEmpty {
                    Text("No results found.")
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    ForEach(vm.sessions, id: \.self) { session in
                        NavigationLink {
                            SessionDetailView(session: session)

                        } label: {
                            SessionRowView(session: session).frame(minHeight: 80)
                        }
                    }
                }
            }
            .navigationTitle("Results")
            .toolbarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Close")
                            .foregroundColor(.primary)
                    })
                }
            })
        }
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

struct SessionRowView: View {
    
    @State var session: Sessions

    var body: some View {
        let connTypeDb = session.connectionType ?? ConnectionType.unknown.rawValue
        let connectionType = ConnectionType(rawValue: connTypeDb) ?? .unknown
        
        HStack {
            VStack {
                switch connectionType {
                case .wifi:
                    Image(systemName: "wifi")
                case .cellular:
                    Image(systemName: "cellularbars")
                case .ethernet:
                    Image(systemName: "cable.connector")
                case .unknown:
                    Image(systemName: "network.slash")
                }
            }
            .foregroundColor(.primary.opacity(0.6))
            .padding(.trailing, 10)

            VStack(alignment: .leading, spacing: 3) {
                Text(session.host ?? "")
                    .font(.title3)

                if let resolvedIpOrHost = session.resolvedIpOrHost {
                   Text(resolvedIpOrHost)
                        .lineLimit(1)
                        .foregroundStyle(.secondary)
                        .font(.subheadline)
                }
                
                if let startDate = session.startDate {
                    Text(formattedRelativeDate(for: startDate))
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                }

            }
            Spacer()

            VStack(alignment: .leading, spacing: 20) {
                Text("\(session.generalScore.formatted(.number.precision(.fractionLength(0))))%")
                    .foregroundColor(.secondary)

                MiniLoadingBar(currentValue: session.generalScore)

            }
            .padding(.horizontal, 8)
            .frame(maxWidth: 90)
        }
        .padding(.vertical, 3)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func formattedRelativeDate(for date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}


#Preview {
    SessionsListView()
}
