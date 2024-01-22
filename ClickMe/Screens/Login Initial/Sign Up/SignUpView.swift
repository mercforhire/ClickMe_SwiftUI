//
//  SignUpView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-01.
//

import SwiftUI

struct SignUpView: View {
    @Binding var navigationPath: [ScreenNames]
    @StateObject var viewModel = SignUpViewModel()
    
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
                    Text("Create an account")
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
                        Image(systemName: "lock.fill")
                        Text("We never share this with anyone and it won't be on your profile.")
                            .font(.body)
                            .fontWeight(.regular)
                            .foregroundColor(.primary)
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
                    CheckboxView(checked: $viewModel.agreeToTermsOfUse, termsOfUseHandler: {
                        viewModel.isPresentingTermsOfUse = true
                    }, privacyHandler: {
                        viewModel.isPresentingPrivacy = true
                    })
                }
                Spacer()
                Button {
                    viewModel.register()
                } label: {
                    CMButton(title: "Register")
                }
                .disabled(!viewModel.agreeToTermsOfUse)
                .padding(.bottom, 20)
            }
            .navigationTitle("Sign up")
            .navigationBarTitleDisplayMode(.large)
            .toolbar() {
                ToolbarItem(placement: .keyboard) {
                    Button("Done") {
                        focusedTextField = nil
                    }
                }
            }
            .padding(.horizontal, 20)
            .fullScreenCover(isPresented: $viewModel.isPresentingTermsOfUse) {
                SafariView(url: URL(string: "https://www.google.com")!,
                           isShowWebView: $viewModel.isPresentingTermsOfUse)
                .ignoresSafeArea()
            }
            .fullScreenCover(isPresented: $viewModel.isPresentingPrivacy) {
                SafariView(url: URL(string: "https://www.yahoo.com")!,
                           isShowWebView: $viewModel.isPresentingPrivacy)
                .ignoresSafeArea()
            }
            if viewModel.isLoading {
                LoadingView()
            }
        }
    }
}

#Preview {
    let viewModel = SignUpViewModel()
    viewModel.emailAddress = "feiyangca@yahoo.ca"
    return NavigationStack {
        SignUpView(navigationPath: .constant([ScreenNames.register]), viewModel: viewModel)
    }
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
