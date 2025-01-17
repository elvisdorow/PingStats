//
//  AddHostFormView.swift
//  PingStats
//
//  Created by Elvis Dorow on 12/12/24.
//
import SwiftUI

struct AddHostFormView: View {
    @Binding var newIpAddress: String
    @Binding var errorMessage: LocalizedStringResource?
    
    var onSave: () -> Void
    
    @Environment(\.presentationMode) var presentationMode
 
    var body: some View {
        VStack {
            
            ZStack(alignment: .top) {
                
                HStack(alignment: .top) {
                    CloseButton {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(12)

                HStack(alignment: .bottom) {
                    Text("New Host")
                        .fontWeight(.semibold)
                        .font(.subheadline)
                }
                .padding(.vertical, 15)
                .padding(.horizontal, 30)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(height: 60, alignment: .top)
            Text("Enter an IP Address or Hostname")
                .font(.subheadline)
            
            
            VStack(alignment: .center, spacing: 20) {
                VStack {
                    TextField("Example: 1.1.1.1 or google.com", text: $newIpAddress)
                        .onChange(of: newIpAddress) { _, _ in
                            validateIPAddressOrHostname()
                        }
                        .autocapitalization(.none)
                        .textFieldStyle(PlainTextFieldStyle())
                        .keyboardType(.asciiCapable)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .frame(height: 50)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .cornerRadius(10)
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(errorMessage == nil ? Color(.systemGray4).opacity(0.3) : .red, lineWidth: 1)
                                .background(Color(.systemGray5).opacity(0.43))
                                .cornerRadius(10)
                                .frame(height: 50)
                        }
                        .foregroundColor(errorMessage == nil ? .primary : .red)
                    
                    if let err = errorMessage {
                        let localizedErrorMessage = String(localized: err)
                        
                        Text(localizedErrorMessage)
                            .padding(.horizontal, 7)
                            .foregroundColor(Color.theme.appRedColor)
                            .font(.caption)

                    }
                }

                saveButton
                    .onTapGesture {
                        onSave()
                    }

                
                Spacer()

            }
            .onAppear {
                errorMessage = nil
            }
            .padding(.horizontal, 30)

        }
   }
    
    @ViewBuilder
    var saveButton: some View {
        VStack {
            Text("Save")
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 50)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.theme.accent)
        }
    }
    
    func validateIPAddressOrHostname() {
        if !newIpAddress.isEmpty && !IPUtils.validateIPAddressOrHostname(newIpAddress) {
            errorMessage = "Invalid host"
        } else {
            errorMessage = nil
        }

        if newIpAddress.isEmpty {
            errorMessage = nil
        }
    }
}

#Preview {
    AddHostFormView(newIpAddress: .constant(""), errorMessage: .constant("")) {
        print("onSave called")
    }
}
