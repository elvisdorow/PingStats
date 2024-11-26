//
//  ResultDetailView.swift
//  PingStats
//
//  Created by Elvis Dorow on 16/09/24.
//

import SwiftUI

struct SessionDetailView: View {
    
    var session: Sessions
//
//    @Environment(\.presentationMode) var presentationMode
//    
//    @State var showDeleteConfirmation: Bool = false
//
    @State var showSessionLogs: Bool = false
        
    init(session: Sessions) {
        self.session = session
    }
    
    var body: some View {
        let connTypeDb = session.connectionType ?? ConnectionType.unknown.rawValue
        let connectionType = ConnectionType(rawValue: connTypeDb) ?? .unknown

        VStack(alignment: .leading, spacing: 8) {
            
            VStack(alignment: .leading) {
                if let hostname = session.hostname {
                    if !hostname.isEmpty {
                        Text(hostname)
                            .lineLimit(1)
                            .foregroundStyle(.secondary)
                            .font(.subheadline)
                    }
                }
                
                HStack(alignment: .firstTextBaseline) {
                    HStack(alignment: .firstTextBaseline) {
                        Text("\(connectionType.toString())")
                        switch connectionType {
                        case .wifi:
                            Image(systemName: "wifi").font(.subheadline)
                        case .cellular:
                            Image(systemName: "cellularbars")
                        case .ethernet:
                            Image(systemName: "cable.connector")
                        case .unknown:
                            Image(systemName: "network.slash")
                        }
                    }
                    .font(.headline)
                    .foregroundColor(.primary.opacity(0.8))
                    Spacer()
                    
                    if let startDate = session.startDate {
                        Text(startDate.formatted(date: .abbreviated, time: .shortened))
                            .font(.callout)
                            .foregroundColor(.primary.opacity(0.6))
                            .padding(.top, 10)
                    }
                }
                .padding(.top, 25)
            }
            .padding(.horizontal, 4)
            
            VStack(spacing: 8) {
                HStack(spacing: 8) {
                    card(title: "Network Quality", value: String(format: "%.0f", session.generalScore) + "%")
                    card(title: "Average", value: String(format: "%.0f ms", session.averagePing))
                }
                HStack(spacing: 8) {
                    card(title: "Jitter", value: String(format: "%.0f ms", session.jitter))
                    card(title: "Packet Loss", value: String(format: "%.0f", session.packageLoss) + "%")
                }
                HStack(spacing: 8) {
                    card(title: "Best Ping", value: String(format: "%.0f ms", session.bestPing))
                    card(title: "Worst Ping", value: String(format: "%.0f ms", session.worstPing))
                }
            }
            
            VStack(spacing: 33) {
                HStack(spacing: 50) {
                    VStack(alignment: .center, spacing: 6) {
                        Text("Elapsed Time").font(.footnote).foregroundColor(.secondary)
                        Text(formattedElapsedTime())
                            .font(.title3)
                    }
                    VStack(alignment: .center, spacing: 6) {
                        Text("Ping Count ").font(.footnote).foregroundColor(.secondary)
                        Text("\(session.pingCount)").font(.title3)
                    }
                }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .center)
                HStack(spacing: 50) {
                    VStack(alignment: .center, spacing: 6) {
                        Text("Ping Interval").font(.footnote).foregroundColor(.secondary)
                        if let interval = PingInterval(rawValue: Int(session.pingInterval)) {
                            Text("\(interval.toString())").font(.title3)
                        }
                    }
                    VStack(alignment: .center, spacing: 6) {
                        Text("Ping Timeout").font(.footnote).foregroundColor(.secondary)
                        if let timeout = PingTimeout(rawValue: Int(session.pingTimeout)) {
                            Text("\(timeout.toString())").font(.title3)
                        }
                    }
                }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .center)
            }
            .padding(10)
            .padding(.vertical, 10)
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.gray.opacity(0.1))
            )
            
            VStack(alignment: .center) {
                buttonViewLogs
            }
            .sheet(isPresented: $showSessionLogs, content: {
                SessionPingLogView(session: session)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            })
            .padding()
            .padding(.vertical)
            .frame(maxWidth: .infinity, alignment: .center)

            Spacer()
        }
        .padding(.horizontal)
        .navigationTitle(session.host ?? "")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                ShareLink(item: "PingStats Result \(session.host ?? "")")
            }
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button(action: {},
                           label: {
                        Label(
                            title: { Text("Save to a file") },
                            icon: { Image(systemName: "square.and.arrow.down") }
                        )
                    })
                    Button(role: .destructive, action: {}) {
                        Label("Delete result", systemImage: "trash")
                    }
                    
                } label: {
                    Label(
                        title: { Text("Menu") },
                        icon: { Image(systemName: "ellipsis.circle") }
                    )
                }
            }
        }.background(Color(uiColor: .systemGray6))
    }
}

extension SessionDetailView {
    func formattedElapsedTime() -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour, .minute, .second]

        // Format the TimeInterval
        if let formattedString = formatter.string(from: self.session.elapsedTime) {
            return formattedString
        }
        return ""
    }
    
    @ViewBuilder
    var buttonViewLogs: some View {
        VStack {
            Label {
                Text("View Logs")
            } icon: {
                Image(systemName: "text.alignleft")
            }
        }
        .foregroundColor(.theme.accent)
        .padding(.horizontal)
        .frame(height: 50)
        .frame(maxWidth: 230)
        .onTapGesture {
            showSessionLogs.toggle()
        }
    }
}


struct card<Content: View>: View {
    var title: String
    var value: String

    let content: Content
    
    init(title: String, value: String, @ViewBuilder content: () -> Content = { EmptyView() }) {
        self.title = title
        self.value = value
        self.content = content()
    }
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 6) {
                Text(title).font(.footnote).foregroundColor(.secondary)
                Text(value).font(.title2).foregroundColor(.primary)
                content
            }
        }
        .padding()
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(uiColor: .systemBackground))
        )
    }
}

/*
struct ResultDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                SessionDetailView(session: Session.example)
            }
        }

        Group {
            card(title: "Best Ping", value: "28.9 ms")
        }
    }
}
*/
