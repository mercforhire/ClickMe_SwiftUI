//
//  SetupBasicInfoView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-02.
//

import SwiftUI

struct SetupBasicInfoView: View {
    @Binding var shouldReturnToLogin: Bool
    @Binding var shouldPresentSetupProfileFlow: Bool
    
    @StateObject var viewModel = SetupBasicInfoViewModel()
    @FocusState private var focusedTextField: FormTextField?
    
    @State private var navigationPath: [ScreenNames] = []
    
    private enum FormTextField {
        case firstName, lastName, city, state, jobTitle, company, degree
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
                    SetupDetailInfoView(basicInfo: viewModel, navigationPath: $navigationPath)
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
                        viewModel.logoutAndQuit()
                        shouldPresentSetupProfileFlow = false
                        shouldReturnToLogin = true
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
    SetupBasicInfoView(shouldReturnToLogin: .constant(false), shouldPresentSetupProfileFlow: .constant(true))
}
