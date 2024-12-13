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
    
    @State var timer: Timer?
    
    enum FocusedTextField: Hashable {
        case textField(String)
    }
    
    @FocusState private var isTextFieldFocused: Bool
    
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
                ToolbarItem(placement: .automatic) {
                    Button(action: {
                        errorMessage = ""
                        newIpAddress = ""
                        showAddForm.toggle()
                    }, label: {
                        
                        Label {
                            Text("Add host")
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
        .sheet(isPresented: $showAddForm) {
            NavigationView {
                VStack {
                    Text("Teste")
                        .navigationTitle("Add host")
                        .navigationBarTitleDisplayMode(.inline)

                    TextField("teste", text: $newIpAddress)
                        .focused($isTextFieldFocused)
                        .onAppear {
    
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                print("textfield appeard")
                                isTextFieldFocused = true
                            }
                        }
                        .onDisappear {
                            isTextFieldFocused = false
                        }
                }
                
                
//                AddHostFormView()
//                    .navigationTitle("Add host")
//                    .navigationBarTitleDisplayMode(.inline)
//                    .toolbar(content: {
//                        ToolbarItem(placement: .cancellationAction) {
//                            CloseButton {
//                                showAddForm = false
//                            }
//                        }
//                        if !newIpAddress.isEmpty && errorMessage.isEmpty {
//                            ToolbarItem(placement: .confirmationAction) {
//                                Button {
//                                    Task {
//                                        await addNewTargetHost()
//                                    }
//                                } label: {
//                                    Text("Save")
//                                }
//                            }
//                        }
//                    })
//                    .interactiveDismissDisabled(false)
//
            }
            .presentationDetents([.height(210)])
        }
    }

//    func AddHostFormView() -> some View {
//        VStack(alignment: .center) {
//            Text("Enter an IP address or host name")
//            TextField("0.0.0.0 or host.name", text: $newIpAddress)
//                .onChange(of: newIpAddress) {
//                    validateIPAddressOrHostname()
//                }
//                .focused($isTextFieldFocused)
//                .onAppear {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
//                        print("show keyboard")
//                        isTextFieldFocused = true
//                    }
//                }
//                .autocapitalization(.none)
//                .textFieldStyle(PlainTextFieldStyle())
//                .frame(height: 50)
//                .multilineTextAlignment(.center)
//                .cornerRadius(10)
//                .background {
//                    RoundedRectangle(cornerRadius: 10)
//                        .stroke(errorMessage.isEmpty ? Color(.systemGray4).opacity(0.3) : .red, lineWidth: 1)
//                        .background(Color(.systemGray5).opacity(0.43))
//                        .cornerRadius(10)
//                        .frame(height: 50)
//                    
//                }
//                .foregroundColor(errorMessage.isEmpty ? .primary : .red)
//                .popover(isPresented: .constant(!errorMessage.isEmpty)) {
//                    Text(errorMessage)
//                        .padding()
//                        .presentationCompactAdaptation(.popover)
//                }
//            }
//            .padding(.horizontal, 30)
//    }
        
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
    
//    func validateIPAddressOrHostname() {
//        if !newIpAddress.isEmpty && !IPUtils.validateIPAddressOrHostname(newIpAddress) {
//            errorMessage = "Invalid host"
//        } else {
//            errorMessage = ""
//        }
//        
//        if newIpAddress.isEmpty {
//            errorMessage = ""
//        }
//    }

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

