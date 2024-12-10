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
    @State var errorMessage: String = ""
    @State var newIpAddress: String = ""
    
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
                        }
                    }
                }
            }
            .toolbar(content: {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        errorMessage = ""
                        newIpAddress = ""
                        showAddForm.toggle()
                    }, label: {
                        Image(systemName: "plus")
                    })
                }
                
                ToolbarItem(placement: .primaryAction) {
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
            try await vm.addNew(ipOrHost: newIpAddress)
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
    func targetHostRow(host: Host) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(host.host)
            }
                
            Spacer()
            if (host.host == settings.host
                && host.type.rawValue == settings.hostType) {
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

