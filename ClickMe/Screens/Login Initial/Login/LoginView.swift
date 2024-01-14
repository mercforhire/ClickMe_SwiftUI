//
//  LoginView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-02.
//

import SwiftUI

struct LoginView: View {
    @Binding var navigationPath: [ScreenNames]
    @StateObject var viewModel = LoginViewModel()
    
    @FocusState private var focusedTextField: FormTextField?
    
    private let screenWidth = UIScreen.main.bounds.size.width
    private let padding: CGFloat = 40
    
    private enum FormTextField {
        case email, code
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Sign in to continue")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .padding(.top, 20)
                    CMEmailTextField(text: $viewModel.emailAddress)
                        .focused($focusedTextField, equals: .email)
                        .onSubmit {
                            viewModel.verifyEmailAddress()
                        }
                    if let emailAddressError = viewModel.emailAddressError, !emailAddressError.isEmpty {
                        CMErrorLabel("\(emailAddressError)")
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
                            CMButton(title: viewModel.getCodeButtonTitle)
                        }
                        .disabled(viewModel.secondsUntilAllowedSendAgain > 0)
                    }
                    if let codeError = viewModel.codeError, !codeError.isEmpty {
                        CMErrorLabel("\(codeError)")
                    }
                }
                Button {
                    Task {
                        await viewModel.login()
                        if viewModel.loginComplete {
                            navigationPath.removeLast()
                        }
                    }
                } label: {
                    CMButton(title: "Login")
                }
                .disabled(!viewModel.loginButtonEnabled)
                .padding(.vertical, 40)
                
                Spacer()
            }
            .navigationTitle("Login")
            .navigationBarTitleDisplayMode(.large)
            .toolbar() {
                ToolbarItem(placement: .keyboard) {
                    Button("Done") {
                        focusedTextField = nil
                    }
                }
            }
            .padding(.horizontal, 20)
            
            if viewModel.isLoading {
                LoadingView()
            }
        }
    }
}

#Preview {
    var viewModel = LoginViewModel()
    viewModel.emailAddress = "feiyangca@yahoo.ca"
    viewModel.code = "6174"
    return LoginView(navigationPath: .constant([ScreenNames.login]), viewModel: viewModel)
}
