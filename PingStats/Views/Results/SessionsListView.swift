//
//  ResultListView.swift
//  PingStats
//
//  Created by Elvis Dorow on 11/09/24.
//

import SwiftUI
import FirebaseAnalytics

struct SessionsListView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var vm = SessionListViewModel()
    
    @State var showDeleteConfirmation: Bool = false
    
    var body: some View {
        
        NavigationView {
            List {
                if vm.sessions.isEmpty {
                    Text("No results found.")
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    Section {
                        ForEach(vm.sessions, id: \.self) { session in
                            NavigationLink {
                                SessionDetailView(session: session, sessions: $vm.sessions)

                            } label: {
                                SessionRowView(session: session).frame(minHeight: 80)
                            }
                        }
                        .onDelete { indexSet in
                            indexSet.forEach { idx in
                                let session = vm.sessions[idx]
                                vm.selectedSession = session
                                showDeleteConfirmation.toggle()
                            }
                        }
                    } header: {
                        HStack {
                            Text("Results found: \(vm.sessions.count)")
                                .font(.subheadline)
                                .padding(.horizontal, 0)

                        }
                        .padding(.vertical, 7)
                        .textCase(nil)
                        
                    }

                }
            }
            .navigationTitle("Results")
            .toolbarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    IconAndTitleButton(title: "Back", systemImage: "chevron.backward") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            })
            .confirmationDialog(
                "Are you sure?",
                isPresented: $showDeleteConfirmation) {
              Button("Delete", role: .destructive) {
                  vm.deleteSession()
                  vm.selectedSession = nil
                  showDeleteConfirmation.toggle()
              }
            } message: {
              Text("Are you sure you want to delete?")
            }
        }
        .toolbarColorScheme(.dark, for: .navigationBar)
        .analyticsScreen(name: "Sessions List")
    }
}

struct SessionRowView: View {
    
    @State var session: Sessions

    var body: some View {
        let connTypeDb = session.connectionType ?? ConnectionType.unknown.toString()
        let connectionType = ConnectionType(fromKey: connTypeDb)
                    
        HStack {
            VStack(spacing: 4) {                
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
                Text("\(connectionType.localizedValue)")
                    .font(.caption)
            }
            .foregroundColor(.primary.opacity(0.6))
            .frame(width: 50)
            .padding(.trailing, 5)

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
