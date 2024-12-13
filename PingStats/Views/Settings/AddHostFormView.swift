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
    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        VStack(alignment: .center) {
            Text("Enter an IP address or host name")
            TextField("0.0.0.0 or host.name", text: $newIpAddress)
                .onChange(of: newIpAddress) { _ in
                    validateIPAddressOrHostname()
                }
                .focused($isTextFieldFocused)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        isTextFieldFocused = true
                    }
                }
                .autocapitalization(.none)
                .textFieldStyle(PlainTextFieldStyle())
                .frame(height: 50)
                .multilineTextAlignment(.center)
                .cornerRadius(10)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(errorMessage.isEmpty ? Color(.systemGray4).opacity(0.3) : .red, lineWidth: 1)
                        .background(Color(.systemGray5).opacity(0.43))
                        .cornerRadius(10)
                        .frame(height: 50)
                }
                .foregroundColor(errorMessage.isEmpty ? .primary : .red)
        }
        .padding(.horizontal, 30)
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
