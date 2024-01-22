//
//  ConnectSetupView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-20.
//

import SwiftUI

struct ConnectSetupView: View {
    @StateObject var viewModel: ConnectSetupViewModel
    @FocusState private var focusedTextField: FormTextField?
    @Binding var navigationPath: [ScreenNames]
    
    private enum FormTextField {
        case email, type, country
    }
    
    init(myUser: User, myProfile: UserProfile, navigationPath: Binding<[ScreenNames]>) {
        _viewModel = StateObject(wrappedValue: ConnectSetupViewModel(myUser: myUser))
        self._navigationPath = navigationPath
    }
    
    var body: some View {
        ZStack {
            Form {
                if let connectedAccount = viewModel.connectedAccount {
                    Section("Connected Account ID") {
                        Text("\(connectedAccount.id)")
                            .textSelection(.enabled)
                    }
                    HStack {
                        Text("Payout enabled")
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Text(connectedAccount.payouts_enabled ? "True" : "False")
                            .foregroundColor(connectedAccount.payouts_enabled ? .primary : .red)
                    }
                    Text("Onboard Stripe Connect Account")
                        .foregroundStyle(Color(.link))
                        .onTapGesture {
                            viewModel.getOnboardLink()
                        }
                }
                
                Section("Account info") {
                    VStack(alignment: .leading) {
                        TextField("Email", text: $viewModel.email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .focused($focusedTextField, equals: .email)
                            .onSubmit {
                                focusedTextField = .type
                            }
                        if let emailError = viewModel.emailError, !emailError.isEmpty {
                            CMErrorLabel(emailError)
                        }
                    }
                    
                    Picker(selection: $viewModel.type, label: Text("Business type")) {
                        ForEach(ConnectAccountTypes.allCases, id: \.self) { type in
                            Text(type.text())
                                .tag(type as ConnectAccountTypes?)
                        }
                    }
                    .focused($focusedTextField, equals: .type)
                    
                    VStack(alignment: .leading) {
                        Picker("Country", selection: $viewModel.country) {
                            ForEach(Country.list(), id: \.self) { country in
                                Text(country.text())
                                    .tag(country)
                            }
                        }
                        .focused($focusedTextField, equals: .country)
                        if let countryError = viewModel.countryError, !countryError.isEmpty {
                            CMErrorLabel(countryError)
                        }
                    }
                    
                    if let setupConnectError = viewModel.setupConnectError, !setupConnectError.isEmpty {
                        CMErrorLabel(setupConnectError)
                    }
                }
            }
            
            if viewModel.isLoading {
                LoadingView()
            }
        }
        .navigationTitle("Stripe Connected Account")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear() {
            viewModel.fetchData()
        }
        .toolbar() {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    viewModel.handleTopRightButton()
                }
            }
        }
        .fullScreenCover(isPresented: $viewModel.isPresentingAccountLink) {
            SafariView(url: URL(string: viewModel.accountLink!.url)!, 
                       isShowWebView: $viewModel.isPresentingAccountLink)
                .ignoresSafeArea()
        }
    }
}

#Preview {
    ClickAPI.shared.apiKey = MockData.mockUser().apiKey
    return NavigationView {
        ConnectSetupView(myUser: MockData.mockUser(), 
                         myProfile: MockData.mockProfile(),
                         navigationPath: .constant([]))
    }
}
