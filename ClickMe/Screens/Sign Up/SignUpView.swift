//
//  SignUpView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-01.
//

import SwiftUI

struct SignUpView: View {
    @StateObject var viewModel = SignUpViewModel()
    @FocusState private var focusedTextField: FormTextField?
    
    enum FormTextField {
        case email, code
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 10) {
                Text("Create an account")
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
                    Image(systemName: "lock.fill")
                    Text("We never share this with anyone and it won't be on your profile.")
                        .font(.body)
                        .fontWeight(.regular)
                        .foregroundColor(.primary)
                }
                HStack {
                    TextField("Verification Code", text: $viewModel.code)
                        .keyboardType(.numberPad)
                        .focused($focusedTextField, equals: .code)
                        .onSubmit {
                            viewModel.verifyCode()
                        }
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
                CheckboxView(checked: $viewModel.agreeToTermsOfUse, termsOfUseHandler: {
                    viewModel.isPresentingTermsOfUse = true
                }, privacyHandler: {
                    viewModel.isPresentingPrivacy = true
                })
                Spacer()
            }
            .navigationTitle("Sign Up")
            .padding(.horizontal, 20)
        }
        .fullScreenCover(isPresented: $viewModel.isPresentingTermsOfUse) {
            SafariView(url: URL(string: "https://www.google.com")!)
                .ignoresSafeArea()
        }
        .fullScreenCover(isPresented: $viewModel.isPresentingPrivacy) {
            SafariView(url: URL(string: "https://www.yahoo.com")!)
                .ignoresSafeArea()
        }
    }
}

#Preview {
    SignUpView()
}

struct CheckboxView: View {
    @Binding var checked: Bool
    var termsOfUseHandler: () -> Void
    var privacyHandler: () -> Void
    
    var body: some View {
        VStack {
            Toggle(isOn: $checked) {
                HStack {
                    Text("By continuing, you're agreeing to our")
                        .font(.footnote)
                        .fontWeight(.regular)
                        .foregroundColor(.primary)
                }
            }
            .toggleStyle(iOSCheckboxToggleStyle())
            .tint(.primary)
            HStack {
                Button {
                    termsOfUseHandler()
                } label: {
                    Text("Terms of Use")
                        .font(.footnote)
                        .fontWeight(.regular)
                        .foregroundColor(Color(.link))
                }
                Text("and")
                    .font(.footnote)
                    .fontWeight(.regular)
                    .foregroundColor(.primary)
                Button {
                    privacyHandler()
                } label: {
                    Text("Privacy Policy")
                        .font(.footnote)
                        .fontWeight(.regular)
                        .foregroundColor(Color(.link))
                }
            }
        }
    }
}
