//
//  AddHostFormView.swift
//  PingStats
//
//  Created by Elvis Dorow on 12/12/24.
//
import SwiftUI

struct AddHostFormView: View {
    @Binding var newIpAddress: String
    @Binding var errorMessage: String
    @FocusState var isTextFieldFocused: Bool

    var body: some View {
        VStack(alignment: .leading) {
            Text("Enter the address:")
                .padding(.horizontal, 5)
            TextField("0.0.0.0 or host.name", text: $newIpAddress)
                .onChange(of: newIpAddress) { _ in
                    validateIPAddressOrHostname()
                }
                .focused($isTextFieldFocused)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        isTextFieldFocused = true
                    }
                }
                .autocapitalization(.none)
                .textFieldStyle(PlainTextFieldStyle())
                .keyboardType(.default) // Set keyboard type
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .frame(height: 50)
                .multilineTextAlignment(.leading)
                .padding(.horizontal)
                .cornerRadius(10)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(errorMessage.isEmpty ? Color(.systemGray4).opacity(0.3) : .red, lineWidth: 1)
                        .background(Color(.systemGray5).opacity(0.43))
                        .cornerRadius(10)
                        .frame(height: 50)
                }
                .foregroundColor(errorMessage.isEmpty ? .primary : .red)
                .popover(isPresented: .constant(!errorMessage.isEmpty)) {
                        Text(errorMessage)
                            .padding()
                            .presentationCompactAdaptation(.popover)
                    }
        }
        .padding(.horizontal, 30)
        .frame(height: 150, alignment: .top)
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

#Preview {
    AddHostFormView(newIpAddress: .constant(""), errorMessage: .constant(""))
}
