//
//  LoginView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-02.
//

import SwiftUI

struct LoginView: View {
    @StateObject var viewModel = LoginViewModel()
    @FocusState private var focusedTextField: FormTextField?
    
    private let screenWidth = UIScreen.main.bounds.size.width
    private let padding: CGFloat = 40
    
    enum FormTextField {
        case email, code
    }
    
    var body: some View {
        ZStack {
            NavigationView {
                VStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Sign in to continue")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                            .padding(.top, 20)
                        TextField("Email", text: $viewModel.emailAddress)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .focused($focusedTextField, equals: .email)
                            .onSubmit {
                                viewModel.verifyEmailAddress()
                            }
                            .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6))
                            .frame(height: 50)
                            .border(.secondary)
                        if let emailAddressError = viewModel.emailAddressError, !emailAddressError.isEmpty {
                            Text("* \(emailAddressError)")
                                .font(.footnote)
                                .fontWeight(.light)
                                .foregroundColor(.red)
                        }
                        HStack {
                            TextField("Verification code", text: $viewModel.code)
                                .keyboardType(.numberPad)
                                .focused($focusedTextField, equals: .code)
                                .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6))
                                .frame(height: 50)
                                .border(.secondary)
                            Button {
                                viewModel.sendCode()
                            } label: {
                                CMButton(title: viewModel.getCodeButtonTitle, width: 120)
                            }
                            .disabled(viewModel.secondsUntilAllowedSendAgain > 0)
                        }
                        if let codeError = viewModel.codeError, !codeError.isEmpty {
                            Text("* \(codeError)")
                                .font(.footnote)
                                .fontWeight(.light)
                                .foregroundColor(.red)
                        }
                    }
                    Button {
                        Task {
                            await viewModel.login()
                        }
                    } label: {
                        CMButton(title: "Login", width: screenWidth - padding * 2)
                    }
                    .disabled(!viewModel.loginButtonEnabled)
                    .padding(.vertical, 40)
                    Spacer()
                }
                .navigationTitle("Login")
                .padding(.horizontal, 20)
            }
            if viewModel.isLoading {
                LoadingView()
            }
        }
    }
}

#Preview {
    var viewModel = LoginViewModel()
    viewModel.emailAddress = "feiyangca@yahoo.ca"
    viewModel.code = "1234"
    return LoginView(viewModel: viewModel)
}
