//
//  CustomerSetupView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-20.
//

import SwiftUI

struct CustomerSetupView: View {
    @StateObject var viewModel: CustomerSetupViewModel
    @FocusState private var focusedTextField: FormTextField?
    @Binding var navigationPath: [ScreenNames]
    
    private enum FormTextField {
        case fullName, email, phone
    }
    
    init(myUser: User, myProfile: UserProfile, navigationPath: Binding<[ScreenNames]>) {
        _viewModel = StateObject(wrappedValue: CustomerSetupViewModel(myUser: myUser, myProfile: myProfile))
        self._navigationPath = navigationPath
    }
    
    var body: some View {
        ZStack {
            Form {
                if let customer = viewModel.customer {
                    Section("Customer ID") {
                        Text("\(customer.id)")
                            .textSelection(.enabled)
                    }
                }
                
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
                    
                    TextField("Phone(optional)", text: $viewModel.phone)
                        .keyboardType(.phonePad)
                        .autocapitalization(.none)
                        .focused($focusedTextField, equals: .phone)
                        .onSubmit {
                            focusedTextField = nil
                        }
                        .onChange(of: viewModel.phone) { phone in
                            if !phone.isEmpty {
                                viewModel.phone = phone.formatPhoneNumber()
                            }
                        }
                }
            }
            
            if viewModel.isLoading {
                LoadingView()
            }
        }
        .navigationTitle("Stripe setup")
        .onAppear() {
            viewModel.fetchData()
        }
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
    ClickAPI.shared.apiKey = MockData.mockUser().apiKey
    return NavigationView {
        CustomerSetupView(myUser: MockData.mockUser(), myProfile: MockData.mockProfile(), navigationPath: .constant([]))
    }
}
