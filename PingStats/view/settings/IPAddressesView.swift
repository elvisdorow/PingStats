//
//  IPAddressesView.swift
//  PingStats
//
//  Created by Elvis Dorow on 03/09/24.
//

import SwiftUI

struct IPAddressesView: View {

    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var settings: Settings

    @State var showAddForm: Bool = false
    @State var errorMessage: String = ""
    @State var newIpAddress: String = ""
    
    var body: some View {
        ZStack {
            List {
                Section {
                    ForEach(Array(settings.ipAddresses.enumerated()), id: \.offset) { idx, ipAddress in
                        HStack {
                            Text(ipAddress)
                            Spacer()
                            if ipAddress == settings.selectedIpAddress {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.accentColor)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            settings.selectedIpAddress = ipAddress
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { idx in
                            settings.ipAddresses.remove(at: idx)
                        }
                    }
                    .onMove(perform: { indices, newOffset in
                        settings.ipAddresses.move(
                            fromOffsets: indices, toOffset: newOffset)
                    })
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
                       
                       if settings.ipAddresses.contains(newIpAddress) {
                           errorMessage = "Host already exists"
                       } else {
                           addIpAddress()
                       }
                       
                       if errorMessage.isEmpty {
                           withAnimation {
                               showAddForm.toggle()
                           }
                       }
                   },
                   primaryActionTitle: "Save",
                   customContent:
                    HStack(alignment: .center) {
                        TextField("0.0.0.0 or host.name", text: $newIpAddress)
                            .onChange(of: newIpAddress) { _ in
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
    
    func validateIPAddressOrHostname() {
        
        if !newIpAddress.isEmpty && !IPValidator.validateIPAddressOrHostname(newIpAddress) {
            errorMessage = "Invalid host"
        } else {
            errorMessage = ""
        }
        
        if newIpAddress.isEmpty {
            errorMessage = ""
        }
    }
    
    func addIpAddress() {
        validateIPAddressOrHostname()
        
        if newIpAddress.isEmpty {
            errorMessage = "Host cannot be empty"
        }

        hostAlreadyExists()
        
        if errorMessage.isEmpty {
            settings.ipAddresses.append(newIpAddress)
            newIpAddress = ""
        }
    }
    
    func hostAlreadyExists() {
        for ipAddress in settings.ipAddresses {
            if ipAddress.lowercased() == newIpAddress.lowercased() {
                errorMessage = "Host already exists"
                break
            }
        }
    }

}


/*
func addIPAddress(_ address: String) -> Error {
    if !SettingsViewModel().isValidIpAddressOrHostname(address) {
        return IpValidationError.invalid
    }
    
    SettingsViewModel().ipAddresses.append(address)
    return nil
}
*/


struct AddIPAddressView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        Group {
//            IPAddressesView()
        }
    }
}

