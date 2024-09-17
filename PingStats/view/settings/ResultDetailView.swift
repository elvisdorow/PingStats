//
//  ResultDetailView.swift
//  PingStats
//
//  Created by Elvis Dorow on 16/09/24.
//

import SwiftUI
import RealmSwift

struct ResultDetailView: View {
    
    let result: MeasurementResult

    @Environment(\.presentationMode) var presentationMode
    
    @State var formattedElapsedTime: String
    
    @State var showDeleteConfirmation: Bool = false
    
    init(result: MeasurementResult) {
        
        self.result = result
        
        let elapsedTime = result.dateEnd.timeIntervalSince(result.dateStart)
        self.formattedElapsedTime = Formatter.elapsedTime(elapsedTime)
    }
    
    var body: some View {
        VStack(spacing: 16) {
            
            HStack(alignment: .bottom) {

                VStack(alignment: .leading) {
                    if !result.hostAddress.isEmpty && !result.ipAddress.isEmpty {
                        Text("IP: \(result.ipAddress)")
                            .font(.title)
                        Text("\(result.hostAddress)")
                            .font(.subheadline)
                    } else {
                        Text(result.hostAddress)
                            .font(.title)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(result.dateStart.formatted(date: .abbreviated, time: .standard))
                        .font(.system(size: 12))
                    
                }
            }
            .padding(.trailing)
            .padding(.leading, 5)
            .padding(.vertical)
            
            
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
            
            VStack(spacing: 20) {
                HStack(spacing: 30) {
                    VStack(alignment: .center, spacing: 6) {
                        Text("Elapsed Time").font(.caption)
                        Text("\(formattedElapsedTime)").font(.title3)
                    }
                    VStack(alignment: .center, spacing: 6) {
                        Text("Ping Count ").font(.caption)
                        Text("\(result.pingCount)").font(.title3)
                    }
                    VStack(alignment: .center, spacing: 6) {
                        Text("Ping Interval").font(.caption)
                        Text("120 ms").font(.title3)
                    }
                    
                }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .center)
            }
            .padding(20)
            .padding(.vertical, 20)
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(.systemGray5), lineWidth: 1)
                    .background(.gray.opacity(0.1))
            )

            VStack {
                Button(action: {
                }, label: {
                    HStack {
                        Image(systemName: "square.and.arrow.down.fill")
                            .imageScale(.large)
                        Text("Download Result")
                    }
                })
            }
            .padding()

            VStack {
                Button(action: {
                    showDeleteConfirmation = true
                }, label: {
                    HStack {
                        Image(systemName: "trash")
                            .imageScale(.large)
                        Text("Delete Result")
                    }
                })
                .font(.system(size: 16))
                .foregroundColor(.red)
            }
            .confirmationDialog("Are you sure you want to delete this result?", isPresented: $showDeleteConfirmation, titleVisibility: .visible) {
                Button("Delete", role: .destructive) {
                    showDeleteConfirmation = false
                    
                    do {
                        let realm = try! Realm()

                        try realm.write {
                            realm.delete(result)
                        }
                    } catch {
                        print(error)
                    }
                    
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .padding()

            
                
            Spacer()
                
        }
        .padding()
        .navigationTitle("Result")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                ShareLink(item: "PingStats Result \(result.hostAddress)")
            }
        }
    }
}

struct card: View {
    var title: String
    var value: String

    var body: some View {
        VStack(alignment: .center, spacing: 6) {
            Text(title).font(.caption)
            Text(value).font(.title2)
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

