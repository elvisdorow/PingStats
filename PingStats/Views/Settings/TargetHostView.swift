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
    
    var settings: Settings = Settings.shared
    
    @State var showAddForm: Bool = false
    @State var errorMessage: String = ""
    @State var newIpAddress: String = ""
    
    var body: some View {
        ZStack {
            List {
                Section {
                    ForEach(vm.targetHosts, id: \.self) { targetHost in
                        targetHostRow(targetHost: targetHost)
                        .onTapGesture {
                            settings.host = targetHost.host ?? ""
                            settings.hostname = targetHost.hostname ?? ""
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { idx in
                            let targetHost = vm.targetHosts[idx]
                            vm.delete(targetHost: targetHost)
                        }
                    }
                }
            }
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        errorMessage = ""
                        newIpAddress = ""
                        showAddForm.toggle()
                    }, label: {
                        Image(systemName: "plus")
                    })
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                }
            })
            
            if showAddForm {
               CustomAlertView(
                   title: "Add host",
                   description: "Enter an IP address or host name",
                   cancelAction: {
                       withAnimation {
                           showAddForm.toggle()
                       }
                   },
                   cancelActionTitle: "Cancel",
                   primaryAction: {
                       Task {
                           await addNewTargetHost()
                       }
                   },
                   primaryActionTitle: "Save",
                   customContent:
                    HStack(alignment: .center) {
                        TextField("0.0.0.0 or host.name", text: $newIpAddress)
                            .onChange(of: newIpAddress) {
                                validateIPAddressOrHostname()
                            }
                        .autocapitalization(.none)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .multilineTextAlignment(.center)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(errorMessage.isEmpty ? Color(.systemGray4) : .red, lineWidth: 1)
                        )
                        .padding()
                        .foregroundColor(errorMessage.isEmpty ? .primary : .red)
                        .popover(isPresented: .constant(!errorMessage.isEmpty)) {
                            Text(errorMessage)
                                .padding()
                                .presentationCompactAdaptation(.popover)
                        }
                    }
               )
           }

        }
    }
    
    func addNewTargetHost() async {
        do {
            try await vm.addNew(host: newIpAddress)
            withAnimation {
                showAddForm.toggle()
            }
        } catch let error {
            errorMessage = error.localizedDescription
        }
    }
    
    func validateIPAddressOrHostname() {
        if !newIpAddress.isEmpty && !IPUtils.validateIPAddressOrHostname(newIpAddress) {
            errorMessage = "Invalid host"
        } else {
            errorMessage = ""
        }
        
        if newIpAddress.isEmpty {
            errorMessage = ""
        }
    }

}

extension TargetHostView {

    @ViewBuilder
    func targetHostRow(targetHost: TargetHost) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(targetHost.host ?? "")
                if let hostname = targetHost.hostname {
                    Text(hostname)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
                
            Spacer()
            if targetHost.host == settings.host {
                Image(systemName: "checkmark")
                    .foregroundColor(Color.theme.accent)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 50)
        .contentShape(Rectangle())
    }
}


struct TargetHostView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationStack {
                TargetHostView()

            }
        }
    }
}

