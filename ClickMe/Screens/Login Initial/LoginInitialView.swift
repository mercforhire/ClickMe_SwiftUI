//
//  LoginInitialView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-01.
//

import SwiftUI

struct LoginInitialView: View {
    @StateObject var viewModel = LoginInitialViewModel()
    @State private var navigationPath: [ScreenNames] = []
    @EnvironmentObject var agora: AgoraManager
    
    var body: some View {
        if viewModel.loggedIn, let userProfile = viewModel.userProfile {
            HomeTabView(myProfile: userProfile)
                .environmentObject(agora)
        } else {
            NavigationStack(path: $navigationPath) {
                ZStack {
                    Image("background", bundle: nil)
                        .resizable()
                        .ignoresSafeArea()
                    VStack(spacing: 10) {
                        Spacer()
                        ImageLogosView()
                        ButtonsSectionView(loginHandler: {
                            navigationPath.append(ScreenNames.login)
                        }, signUpHandler: {
                            navigationPath.append(ScreenNames.register)
                        })
                        Spacer()
                        FooterView(termsOfUseHandler: {
                            viewModel.isPresentingTermsOfUse = true
                        }, privacyHandler: {
                            viewModel.isPresentingPrivacy = true
                        })
                        .padding(.bottom, 10)

                    }
                }
                .navigationDestination(for: ScreenNames.self) { screenName in
                    switch screenName {
                    case ScreenNames.login:
                        LoginView(navigationPath: $navigationPath)
                    case ScreenNames.register:
                        SignUpView(navigationPath: $navigationPath)
                    default:
                        fatalError()
                    }
                }
                .fullScreenCover(isPresented: $viewModel.isPresentingTermsOfUse) {
                    SafariView(url: URL(string: "https://www.google.com")!)
                        .ignoresSafeArea()
                }
                .fullScreenCover(isPresented: $viewModel.isPresentingPrivacy) {
                    SafariView(url: URL(string: "https://www.yahoo.com")!)
                        .ignoresSafeArea()
                }
                .onAppear {
                    viewModel.checkIfAppIsLoggedIn()
                }
            }
        }
    }
}

#Preview {
    LoginInitialView()
}

struct ImageLogosView: View {
    private let screenWidth = UIScreen.main.bounds.size.width
    
    var body: some View {
        VStack {
            Image("logotype", bundle: nil)
                .resizable()
                .scaledToFill()
                .frame(width: 200, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .foregroundColor(.accentColor)
            Text("Every click connects")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.accentColor)
            Image("click", bundle: nil)
                .resizable()
                .scaledToFill()
                .frame(width: screenWidth * 0.8, height: screenWidth * 0.6, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .padding(.horizontal, 30)
        }
    }
}

struct ButtonsSectionView: View {
    var loginHandler: () -> Void
    var signUpHandler: () -> Void
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Welcome")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .fontWeight(.bold)
                .foregroundColor(.white)
            Text("Please Login or Sign up to continue")
                .font(.body)
                .fontWeight(.regular)
                .foregroundColor(.primary)
                .padding(.horizontal, 40)
            Button {
                loginHandler()
            } label: {
                CMButton(title: "Login")
            }
            .padding(.vertical, 10)
            HStack {
                Text("Not a member?")
                    .font(.body)
                    .fontWeight(.regular)
                    .foregroundColor(.primary)
                Button {
                    signUpHandler()
                } label: {
                    Text("Sign Up")
                        .font(.body)
                        .fontWeight(.regular)
                        .foregroundColor(Color(.link))
                }
            }
        }
    }
}

struct FooterView: View {
    var termsOfUseHandler: () -> Void
    var privacyHandler: () -> Void
    
    var body: some View {
        VStack {
            Text("By continuing, you're agreeing to our")
                .font(.footnote)
                .fontWeight(.regular)
                .foregroundColor(.primary)
            HStack {
                Button {
                    termsOfUseHandler()
                } label: {
                    Text("Terms of Use")
                        .font(.body)
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
                        .font(.body)
                        .fontWeight(.regular)
                        .foregroundColor(Color(.link))
                }
            }
        }
    }
}
