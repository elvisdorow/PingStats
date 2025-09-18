//
//  ResultDetailView.swift
//  PingStats
//
//  Created by Elvis Dorow on 16/09/24.
//

import SwiftUI
import FirebaseAnalytics
import SimpleToast

struct SessionDetailView: View {
    
    @State var showSessionLogs: Bool = false
    @State var showShareSheet: Bool = false
    @State var showDeleteConfirmation: Bool = false
    
    @State var showSaveConfirmation: Bool = false
        
    @StateObject var vm: SessionDetailViewModel
    
    @Binding var sessions: [Sessions]
    
    @Environment(\.dismiss) var dismiss

    private let toastOptions = SimpleToastOptions(
        hideAfter: 3
    )
    
    init(session: Sessions, sessions: Binding<[Sessions]>) {
        self._vm = StateObject(wrappedValue: SessionDetailViewModel(session: session))
        self._sessions = sessions
    }
    
    var body: some View {
        let connTypeDb = vm.session.connectionType ?? ConnectionType.unknown.toString()
        let connectionType = ConnectionType(fromKey: connTypeDb)

        VStack(alignment: .leading, spacing: 10) {
            
            VStack(alignment: .leading) {
                if let resolvedIpOrHost = vm.session.resolvedIpOrHost {
                    Text(resolvedIpOrHost)
                        .lineLimit(1)
                        .foregroundStyle(.secondary)
                        .font(.subheadline)
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
                    
                    if let startDate = vm.session.startDate {
                        Text(startDate.formatted(date: .abbreviated, time: .shortened))
                            .font(.callout)
                            .foregroundColor(.primary.opacity(0.6))
                            .padding(.top, 10)
                    }
                }
                .padding(.top, 15)
                .padding(.bottom, 10)
            }
            .padding(.horizontal, 4)
            
            VStack(spacing: 10) {
                HStack(spacing: 10) {
                    card(title: "Network Quality", value: String(format: "%.0f", vm.session.generalScore) + "%")
                    card(title: "Average", value: String(format: "%.0f ms", vm.session.averagePing))
                }
                HStack(spacing: 8) {
                    card(title: "Jitter", value: String(format: "%.0f ms", vm.session.jitter))
                    card(title: "Packet Loss", value: String(format: "%.0f", vm.session.packageLoss) + "%")
                }
                HStack(spacing: 8) {
                    card(title: "Best Ping", value: String(format: "%.0f ms", vm.session.bestPing))
                    card(title: "Worst Ping", value: String(format: "%.0f ms", vm.session.worstPing))
                }
            }

            VStack(spacing: 25) {
                
                Grid(alignment: .center, horizontalSpacing: 15, verticalSpacing: 15) {
                    GridRow {
                        VStack(alignment: .center, spacing: 5) {
                            Text("Elapsed Time").font(.footnote).foregroundColor(.secondary)
                            Text(formattedElapsedTime())
                                .font(.title3)
                        }
                        VStack(alignment: .center, spacing: 5) {
                            Text("Ping Count ").font(.footnote).foregroundColor(.secondary)
                            Text("\(vm.session.pingCount)").font(.title3)
                        }
                    }
                    
                    GridRow {
                        VStack(alignment: .center, spacing: 5) {
                            Text("Ping Interval").font(.footnote).foregroundColor(.secondary)
                            if let interval = PingInterval(rawValue: Int(vm.session.pingInterval)) {
                                Text("\(interval.toString())").font(.title3)
                            }
                        }
                        VStack(alignment: .center, spacing: 5) {
                            Text("Ping Timeout").font(.footnote).foregroundColor(.secondary)
                            if let timeout = PingTimeout(rawValue: Int(vm.session.pingTimeout)) {
                                Text("\(timeout.toString())").font(.title3)
                            }
                        }

                    }
                }
                .frame(maxWidth: .infinity)

            }
            .padding(5)
            .padding(.vertical, 5)
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.gray.opacity(0.1))
            )
            
            VStack {
                buttonViewLogs
            }
            .frame(maxHeight: 60)
            .simpleToast(isPresented: $showSaveConfirmation, options: toastOptions) {
                ToastMessage(message: "Result saved in files.")
            }
            .sheet(isPresented: $showShareSheet) {
                ActivityView(activityItems: [vm.fileURL!as Any])
            }
            .sheet(isPresented: $showSessionLogs, content: {
                SessionPingLogView(session: vm.session)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            })
            .confirmationDialog(
                "Are you sure?",
                isPresented: $showDeleteConfirmation) {
              Button("Delete", role: .destructive) {
                  showDeleteConfirmation.toggle()
                  vm.deleteSession()
                  
                  // Remove the session from the binding list
                  if let index = sessions.firstIndex(where: { $0 == vm.session }) {
                      sessions.remove(at: index)
                  }
                  
                  dismiss()
              }
            } message: {
              Text("Are you sure you want to delete?")
            }

            .padding()
            .padding(.vertical)
            .frame(maxWidth: .infinity, alignment: .center)

        }
        .padding(.horizontal)
        .navigationTitle(vm.session.host ?? "")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    
                    // share session button
                    Button(action: {
                        vm.shareSession()
                        
                        if vm.fileURL != nil {
                            showShareSheet.toggle()
                        }

                    },
                        label: {
                        Label(
                            title: { Text("Share") },
                            icon: { Image(systemName: "square.and.arrow.up") }
                        )
                    })
                    
                    // save session button
                    Button(action: {
                        vm.saveSessionToFile()
                        showSaveConfirmation.toggle()
                    },
                        label: {
                        Label(
                            title: { Text("Save in Files") },
                            icon: { Image(systemName: "square.and.arrow.down") }
                        )
                    })
                    
                    Button(role: .destructive, action: {
                        showDeleteConfirmation.toggle()
                    })
                    {
                        Label("Delete", systemImage: "trash")
                    }
                    .tint(Color.theme.appRedColor)

                    
                } label: {
                    if #available(iOS 26.0, *) {
                        Label("More", systemImage: "ellipsis")
                    } else {
                        Label("More", systemImage: "ellipsis.circle")

                    }
                        
                }
                .tint(.primary)
            }
            
        }
        .tint(.primary)
        .background(Color(uiColor: .systemGray6))
        .analyticsScreen(name: "Session Detail")

    }
}

extension SessionDetailView {
    func formattedElapsedTime() -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour, .minute, .second]

        // Format the TimeInterval
        if let formattedString = formatter.string(from: vm.session.elapsedTime) {
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
//        .frame(height: 50)
        .frame(maxWidth: 230)
        .onTapGesture {
            showSessionLogs.toggle()
        }
    }
}

struct card<Content: View>: View {
    var title: LocalizedStringKey
    var value: String

    let content: Content
    
    let screenHeight = UIScreen.main.bounds.height
    
    init(title: LocalizedStringKey, value: String, @ViewBuilder content: () -> Content = { EmptyView() }) {
        self.title = title
        self.value = value
        self.content = content()
    }
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: screenHeight * 0.01) {
                Text(title).font(.footnote).foregroundColor(.secondary)
                Text(value).font(.title2).foregroundColor(.primary)
                content
            }
        }
        .padding(.horizontal, screenHeight * 0.025)
        .padding(.vertical, screenHeight * 0.01)
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(uiColor: .systemBackground))
        )
    }
}
