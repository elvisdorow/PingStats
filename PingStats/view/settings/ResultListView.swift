//
//  ResultListView.swift
//  PingStats
//
//  Created by Elvis Dorow on 11/09/24.
//

import SwiftUI
import RealmSwift

struct ResultListView: View {
    
    @ObservedResults(MeasurementResult.self, sortDescriptor: SortDescriptor(keyPath: "dateStart", ascending: false)) var results

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            
            List {
                if results.isEmpty {
                    Text("No results found.")
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    ForEach(results, id: \.id) { result in
                        NavigationLink {
                            ResultDetailView(result: result)

                        } label: {
                            ResultRowView(result: result)
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
                        Image(systemName: "xmark")
                    })
                }
            })
        }
    }
}

struct ResultRowView: View {
    
    var result: MeasurementResult
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                if !result.hostAddress.isEmpty && !result.ipAddress.isEmpty {
                    Text("\(result.ipAddress)")
                        .font(.system(size: 18))

                    Text("\(result.hostAddress)").foregroundStyle(.secondary)
                        .font(.system(size: 18))
                } else {
                    Text(result.hostAddress)
                        .font(.system(size: 18))
                }
                
                Text(formattedRelativeDate(for: result.dateStart))
                    .foregroundColor(.secondary)
                    .font(.system(size: 15))

            }
            Spacer()

            HStack {
                Text("\(result.generalNetQuality.formatted(.number.precision(.fractionLength(0))))%")
                dotCircleStatus(quality: result.generalNetQuality)
                    .font(.caption)
            }
            .foregroundColor(.secondary)
            .padding(.horizontal, 8)
        }
        .padding(.vertical, 3)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func formattedRelativeDate(for date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: date, relativeTo: Date())
    }
    
    func dotCircleStatus(quality: Double) -> some View {
        
        var color: Color = .green
        
        switch quality {
        case 0...40:
            color = .red
        case 41...60:
            color = .orange
        case 61...80:
            color = .yellow
        case 81...100:
            color = .green
        default:
            color = .gray
        }
        
        return Circle()
            .foregroundColor(color)
            .frame(width: 10, height: 10)
    }

}


#Preview {
    ResultRowView(result: MeasurementResult.example)
}
