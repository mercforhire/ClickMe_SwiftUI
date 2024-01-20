//
//  StripeCustomerSetupView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-20.
//

import SwiftUI

struct StripeCustomerSetupView: View {
    @StateObject var viewModel: StripeCustomerSetupViewModel
    @FocusState private var focusedTextField: FormTextField?
    @Binding var navigationPath: [ScreenNames]
    
    private enum FormTextField {
        case fullName, email, phone
    }
    
    init(myUser: User, navigationPath: Binding<[ScreenNames]>) {
        _viewModel = StateObject(wrappedValue: StripeCustomerSetupViewModel(myUser: myUser))
        self._navigationPath = navigationPath
    }
    
    var body: some View {
        Form {
            Section("Customer info") {
                VStack(alignment: .leading) {
                    TextField("Full name", text: $viewModel.fullName)
                        .keyboardType(.alphabet)
                        .autocapitalization(.words)
                        .focused($focusedTextField, equals: .fullName)
                        .onSubmit {
                            focusedTextField = .email
                    }
                    if let fullNameError = viewModel.fullNameError, !fullNameError.isEmpty {
                        CMErrorLabel(fullNameError)
                    }
                }
                
                VStack(alignment: .leading) {
                    TextField("Email", text: $viewModel.email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .focused($focusedTextField, equals: .email)
                        .onSubmit {
                            focusedTextField = .phone
                    }
                    if let emailError = viewModel.emailError, !emailError.isEmpty {
                        CMErrorLabel(emailError)
                    }
                }
                
                TextField("Phone", text: $viewModel.phone)
                    .keyboardType(.phonePad)
                    .autocapitalization(.none)
                    .focused($focusedTextField, equals: .phone)
                    .onSubmit {
                        focusedTextField = nil
                }
            }
        }
        .navigationTitle("Stripe setup")
        .toolbar() {
            ToolbarItem(placement: .topBarTrailing) {
                Button(viewModel.customer != nil ? "Save" : "Submit") {
                    viewModel.submitData()
                }
            }
        }
        .onChange(of: viewModel.setupCustomerComplete) { success in
            if success {
                navigationPath.removeLast()
            }
        }
    }
}

#Preview {
    NavigationView {
        StripeCustomerSetupView(myUser: MockData.mockUser(), navigationPath: .constant([]))
    }
}
