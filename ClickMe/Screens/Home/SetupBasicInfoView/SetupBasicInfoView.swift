//
//  SetupBasicInfoView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-02.
//

import SwiftUI

struct SetupBasicInfoView: View {
    @Binding var shouldPresentSetupProfileFlow: Bool
    @StateObject var viewModel: SetupBasicInfoViewModel
    
    @FocusState private var focusedTextField: FormTextField?
    @State private var navigationPath: [ScreenNames] = []
    
    private enum FormTextField {
        case firstName, lastName, city, state, jobTitle, company, degree
    }
    
    init(myProfile: UserProfile, shouldPresentSetupProfileFlow: Binding<Bool>) {
        _shouldPresentSetupProfileFlow = shouldPresentSetupProfileFlow
        _viewModel = StateObject(wrappedValue: SetupBasicInfoViewModel(myProfile: myProfile))
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            Form {
                Section(header: Text("Personal info")) {
                    VStack(alignment: .leading) {
                        TextField("First name", text: $viewModel.firstName)
                            .keyboardType(.alphabet)
                            .autocapitalization(.words)
                            .focused($focusedTextField, equals: .firstName)
                            .onSubmit {
                                focusedTextField = .firstName
                        }
                        if let firstNameError = viewModel.firstNameError, !firstNameError.isEmpty {
                            CMErrorLabel(firstNameError)
                        }
                    }
                    VStack(alignment: .leading) {
                        TextField("Last name", text: $viewModel.lastName)
                            .keyboardType(.alphabet)
                            .autocapitalization(.words)
                            .focused($focusedTextField, equals: .lastName)
                            .onSubmit {
                                focusedTextField = .lastName
                            }
                        if let lastNameError = viewModel.lastNameError, !lastNameError.isEmpty {
                            CMErrorLabel(lastNameError)
                        }
                    }
                    TextField("City", text: $viewModel.city)
                        .focused($focusedTextField, equals: .city)
                        .keyboardType(.alphabet)
                        .autocapitalization(.words)
                        .onSubmit {
                            focusedTextField = .state
                        }
                    TextField("State", text: $viewModel.state)
                        .focused($focusedTextField, equals: .state)
                        .keyboardType(.alphabet)
                        .autocapitalization(.words)
                        .onSubmit {
                            focusedTextField = nil
                        }
                    Picker("Country", selection: $viewModel.country) {
                        ForEach(Country.list(), id: \.self) { country in
                            Text(country.text()).tag(country)
                        }
                    }
                }
                Section(header: Text("Profession info")) {
                    Picker("Field", selection: $viewModel.field) {
                        ForEach(Field.list(), id: \.self) { field in
                            Text(field.text()).tag(field)
                        }
                    }
                    TextField("Job title", text: $viewModel.jobTitle)
                        .focused($focusedTextField, equals: .jobTitle)
                        .keyboardType(.alphabet)
                        .autocapitalization(.sentences)
                        .onSubmit {
                            focusedTextField = .company
                        }
                    TextField("Company", text: $viewModel.company)
                        .focused($focusedTextField, equals: .company)
                        .keyboardType(.alphabet)
                        .autocapitalization(.sentences)
                        .onSubmit {
                            focusedTextField = .degree
                        }
                    TextField("Degree", text: $viewModel.degree)
                        .focused($focusedTextField, equals: .degree)
                        .keyboardType(.alphabet)
                        .autocapitalization(.words)
                        .onSubmit {
                            focusedTextField = nil
                        }
                }
            }
            .navigationDestination(for: ScreenNames.self) { screenName in
                switch screenName {
                case ScreenNames.setupDetailInfo:
                    SetupDetailInfoView(myProfile: viewModel.myProfile,
                                        basicInfo: viewModel,
                                        shouldPresentSetupProfileFlow: $shouldPresentSetupProfileFlow,
                                        navigationPath: $navigationPath)
                default:
                    fatalError()
                }
            }
            .navigationTitle("Setup profile")
            .toolbar() {
                ToolbarItem(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        focusedTextField = nil
                    }
                }
            }
            .toolbar() {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Log out") {
                        viewModel.handleLogOut()
                        shouldPresentSetupProfileFlow = false
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Next") {
                        if viewModel.isValidForm {
                            navigationPath.append(ScreenNames.setupDetailInfo)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    SetupBasicInfoView(myProfile: MockData.mockProfile(), shouldPresentSetupProfileFlow: .constant(true))
}
