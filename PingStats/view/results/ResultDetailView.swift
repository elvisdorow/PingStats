//
//  ResultDetailView.swift
//  PingStats
//
//  Created by Elvis Dorow on 16/09/24.
//

import SwiftUI
import RealmSwift

struct ResultDetailView: View {
    
    var result: MeasurementResult
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var showDeleteConfirmation: Bool = false
    
    init(result: MeasurementResult) {
        self.result = result
    }
    
    var body: some View {
        
        let connectionType = ConnectionType(rawValue: result.connectionType) ?? .unknown
        
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading) {
                if !result.hostAddress.isEmpty && !result.ipAddress.isEmpty {
                    Text("\(result.hostAddress)")
                        .foregroundColor(.secondary)
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
                    .foregroundColor(.primary.opacity(0.9))

                    Spacer()

                    Text(result.dateStart.formatted(date: .abbreviated, time: .standard))
                        .font(.system(size: 15)).foregroundColor(.primary.opacity(0.9))
                        .padding(.top, 10)

                }
            }
            .padding(.horizontal, 4)

            
            
            VStack(spacing: 15) {
                HStack(spacing: 15) {
                    card(title: "Average", value: String(format: "%.0f ms", result.avaragePing))
                    card(title: "Network Quality", value: String(format: "%.0f", result.generalNetQuality) + "%")
                }
                HStack(spacing: 15) {
                    card(title: "Jitter", value: String(format: "%.0f ms", result.jitter))
                    card(title: "Packet Loss", value: String(format: "%.0f", result.packageLoss))
                }
                HStack(spacing: 15) {
                    card(title: "Best Ping", value: String(format: "%.0f ms", result.bestPing))
                    card(title: "Worst Ping", value: String(format: "%.0f ms", result.worstPing))
                }
            }
            
            VStack(spacing: 33) {
                HStack(spacing: 50) {
                    VStack(alignment: .center, spacing: 6) {
                        Text("Elapsed Time")
                        Text("\(result.elapsedTime)").font(.title3)
                    }
                    VStack(alignment: .center, spacing: 6) {
                        Text("Ping Count ")
                        Text("\(result.pingCount)").font(.title3)
                    }
                }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .center)
                HStack(spacing: 50) {
                    VStack(alignment: .center, spacing: 6) {
                        Text("Ping Interval")
                        if let interval = PingInterval(rawValue: result.pingInterval) {
                            Text("\(interval.toString())").font(.title3)
                        }
                    }
                    VStack(alignment: .center, spacing: 6) {
                        Text("Ping Timeout")
                        if let timeout = PingTimeout(rawValue: result.pingTimeout) {
                            Text("\(timeout.toString())").font(.title3)
                        }
                    }
                }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .center)
            }
            .padding(10)
            .padding(.vertical, 10)
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(.systemGray5), lineWidth: 1)
                    .background(.gray.opacity(0.1))
            )

            
                
            Spacer()
                
        }
        .padding(.horizontal)
        .navigationTitle((!result.ipAddress.isEmpty) ? "\(result.ipAddress)" : "\(result.hostAddress)")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                ShareLink(item: "PingStats Result \(result.hostAddress)")
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
        }
    }
}

struct card: View {
    var title: String
    var value: String

    var body: some View {
        VStack(alignment: .center, spacing: 6) {
            Text(title).font(.subheadline).foregroundColor(.secondary)
            Text(value).font(.title).foregroundColor(.primary.opacity(0.75))
        }
        .padding()
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .center)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.systemGray5), lineWidth: 1)
        )
    }
}



struct ResultDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                ResultDetailView(result: MeasurementResult.example)
            }
        }

        Group {
            card(title: "Best Ping", value: "28.9 ms")
        }
    }
}

