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
            NavigationView {
                AddHostFormView(newIpAddress: $newIpAddress, errorMessage: $errorMessage)
                    .navigationTitle("New Host")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar(content: {
                        ToolbarItem(placement: .cancellationAction) {
                            CloseButton {
                                showAddForm = false
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button {
                                Task {
                                    await addNewTargetHost()
                                }
                            } label: {
                                Text("Save")
                            }
                        }
                    })
                    .interactiveDismissDisabled(false)

            }
            .presentationDetents([.height(220)])
        }
        .toolbar(content: {
            ToolbarItem(placement: .automatic) {
                Button(action: {
                    newIpAddress = ""
                    showAddForm.toggle()
                }, label: {
                    
                    Label {
                        Text("New Host")
                    } icon: {
                        Image(systemName: "plus")
                    }
                })
            }
            
            ToolbarItem(placement: .primaryAction) {
                EditButton()
            }
        })
    }
        
    func addNewTargetHost() async {
        do {
            let host = try await vm.addNew(ipOrHost: newIpAddress)
            settings.host = host.host
            settings.hostType = host.type.rawValue
            
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

struct AddFormView: View {
    @FocusState var isTextFieldFocused: Bool
    
    var body: some View {
        VStack {
            Text("Teste")
                .navigationTitle("Add host")
                .navigationBarTitleDisplayMode(.inline)

            TextField("teste", text: .constant(""))
                .focused($isTextFieldFocused)
                .onAppear {

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                        print("textfield appeard")
                        isTextFieldFocused = true
                    }
                }
                .onDisappear {
                    isTextFieldFocused = false
                }
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

