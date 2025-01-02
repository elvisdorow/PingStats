//
//  IPAddressesView.swift
//  PingStats
//
//  Created by Elvis Dorow on 03/09/24.
//

import SwiftUI

struct TargetHostView: View {

    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var vm: TargetHostViewModel = TargetHostViewModel()
    
    var pingerService = PingService.instance    
    var settings = Settings.shared
    
    @State var showAddForm: Bool = false
    @State var newIpAddress: String = ""
    @State var errorMessage: String = ""
    
    @State var timer: Timer?
    
    var body: some View {
        ZStack {
            List {
                Section {
                    ForEach(vm.hosts, id: \.id) { host in
                        targetHostRow(host: host)
                        .onTapGesture {
                            settings.host = host.host
                            settings.hostType = host.type.rawValue
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { idx in
                            let host = vm.hosts[idx]
                            vm.delete(host: host)
                            vm.reload()
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showAddForm) {
            AddHostFormView(
                newIpAddress: $newIpAddress,
                errorMessage: $errorMessage,
                onSave: {
                    Task {
                        await addNewTargetHost()
                    }
                })
            .presentationDetents([.height(240), .height(250)])
        }
        .toolbar(content: {
            
            ToolbarItem(placement: .bottomBar) {
                IconAndTitleButton(
                    title: "New Host",
                    systemImage: "plus.circle.fill",
                    action: {
                        newIpAddress = ""
                        showAddForm.toggle()
                    })
            }
        })
    }
        
    func addNewTargetHost() async {
        do {
            let _ = try await vm.addNew(ipOrHost: newIpAddress)
            
            vm.reload()
            
            withAnimation {
                showAddForm.toggle()
            }
        } catch IpHostError.alreadyExists {
            errorMessage = "Host already exists"
        } catch IpHostError.invalid {
            errorMessage = "Invalid host"
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

extension TargetHostView {
    @ViewBuilder
    func targetHostRow(host: Host) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(host.host)
            }
            Spacer()
            RadioButton(isSelected: isSelected(host))
        }
        .frame(height: 38)
        .contentShape(Rectangle()) // Improves tap area
    }

    private func isSelected(_ host: Host) -> Bool {
        host.host == settings.host && host.type.rawValue == settings.hostType
    }
}

// MARK: - Custom RadioButton View
struct RadioButton: View {
    let isSelected: Bool

    var body: some View {
        ZStack {
            Circle()
                .stroke(isSelected ? Color.theme.accent : .secondary.opacity(0.4), lineWidth: 2) // Outer circle
                .frame(width: 18, height: 18)
            
            if isSelected {
                Circle()
                    .fill(Color.theme.accent) // Inner filled circle for selected state
                    .frame(width: 12, height: 12)
            }
        }
    }
}

struct TargetHostView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationStack {
                TargetHostView()

            }
        }
        
        Group {
            RadioButton(isSelected: true)
        }
    }
}

