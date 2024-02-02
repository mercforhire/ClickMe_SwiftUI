//
//  LoginView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-02.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

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
                            .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
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
                    viewModel.login()
                } label: {
                    CMButton(title: "Login", fullWidth: true)
                }
                .disabled(!viewModel.loginButtonEnabled)
                .padding(.top, 40)
                .padding(.horizontal, 20)
                
                GoogleSignInButton(scheme: .dark, style: .wide) {
                    
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 20)
                .padding(.horizontal, 20)
                
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
        .onAppear {
            GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                // Check if `user` exists; otherwise, do something with `error`
            }
        }
    }
}

#Preview {
    let viewModel = LoginViewModel()
    viewModel.emailAddress = "feiyangca@yahoo.ca"
    viewModel.code = "6174"
    return NavigationStack {
        LoginView(navigationPath: .constant([ScreenNames.login]), viewModel: viewModel)
    }
}
