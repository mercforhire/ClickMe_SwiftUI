//
//  EditProfileView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-09.
//

import SwiftUI

struct EditProfileView: View {
    private enum FormTextField {
        case firstName, lastName, city, state, jobTitle, company, degree, aboutMe
    }
    
    @StateObject private var viewModel: EditProfileViewModel
    @Binding var navigationPath: [ScreenNames]
    
    @FocusState private var focusedTextField: FormTextField?
    
    init(myProfile: UserProfile, navigationPath: Binding<[ScreenNames]>) {
        _viewModel = StateObject(wrappedValue: EditProfileViewModel(myProfile: myProfile))
        self._navigationPath = navigationPath
    }
    
    private let screenWidth = UIScreen.main.bounds.size.width
    private let padding: CGFloat = 50
    private var photoCellWidth: CGFloat {
        return (screenWidth * 0.6)
    }
    private var gridMatrix: [GridItem] = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ZStack {
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
                
                Section(header: Text("About me")) {
                    TextEditor(text: $viewModel.aboutMe)
                        .focused($focusedTextField, equals: .aboutMe)
                        .foregroundStyle(.primary)
                        .frame(height: 200)
                        .keyboardType(.alphabet)
                    if let aboutMeError = viewModel.aboutMeError, !aboutMeError.isEmpty {
                        CMErrorLabel(aboutMeError)
                    }
                }
                
                Section(header: Text("I speak")) {
                    MultiSelector(
                        label: Text("Languages"),
                        options: Language.list(),
                        optionToString: { $0.text() },
                        selected: $viewModel.languages
                    )
                    
                    if let languagesError = viewModel.languagesError, !languagesError.isEmpty {
                        CMErrorLabel(languagesError)
                    }
                }
            }
            .navigationTitle("Edit profile")
            .toolbar() {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("", systemImage: "camera") {
                        viewModel.isPresentingEditPhotosScreen = true
                    }
                    
                    Button("Save") {
                        viewModel.handleSaveAction()
                    }
                }
                
            }
            .onChange(of: viewModel.updateProfileFinished) { updateProfileFinished in
                if updateProfileFinished {
                    navigationPath.removeLast()
                }
            }
            .alert(isPresented: $viewModel.updateProfileError) {
                Alert(title: Text("Server error"),
                      message: Text("Something went wrong while updating profile"),
                      dismissButton: .default(Text("Ok")))
            }
            .popover(isPresented: $viewModel.isPresentingEditPhotosScreen) {
                EditPhotosView(isPresentingEditPhotosScreen: $viewModel.isPresentingEditPhotosScreen)
                    .environmentObject(viewModel)
            }
            
            if viewModel.isLoading {
                LoadingView()
            }
        }
    }
}

#Preview {
    EditProfileView(myProfile: MockData.mockProfile(), navigationPath: .constant([.editProfile]))
}
