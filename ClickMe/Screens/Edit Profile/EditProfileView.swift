//
//  EditProfileView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-09.
//

import SwiftUI

struct EditProfileView: View {
    @StateObject private var viewModel: EditProfileViewModel
    @Binding var navigationPath: [ScreenNames]
    
    private enum FormTextField {
        case firstName, lastName, city, state, jobTitle, company, degree, aboutMe
    }
    
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
            
            Section(header: Text("Photos")) {
                ForEach(Array(viewModel.userPhotos.enumerated()), id: \.element.id) { photo in
                    HStack(alignment: .center) {
                        AsyncImage(url: URL(string: photo.thumbnail)) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            Color.accentColor
                        }
                        .frame(width: photoCellWidth, height: 150)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        
                        Spacer()
                        
                        Image(systemName: "line.3.horizontal")
                            .resizable()
                            .foregroundColor(.secondary)
                            .frame(width: 25, height: 20)
                    }
                    .id(photo.id)
                    .onDrag {
                        viewModel.draggedPhoto = photo
                        return NSItemProvider(object: String(photo.id) as NSString)
                    }
                    .onDrop(of: [.text], delegate:
                                DragRelocateDelegate(
                                    destinationItem: photo,
                                    photos: $viewModel.userPhotos,
                                    draggedItem: $viewModel.draggedPhoto)
                    )
                }
                
                Button {
                    viewModel.handlePhotoPicker()
                } label: {
                    Image(systemName: "camera")
                        .imageScale(.large)
                        .foregroundColor(.accentColor)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
                if let photosError = viewModel.photosError, !photosError.isEmpty {
                    CMErrorLabel(photosError)
                }
            }
            .alert(isPresented: $viewModel.s3UploadError) {
                Alert(title: Text("Upload error"),
                      message: Text("Something went wrong while uploading to S3"),
                      dismissButton: .default(Text("Ok")))
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
        .navigationTitle("Edit Profile")
        .toolbar() {
            Button("Save") {
                viewModel.handleSaveAction()
            }
        }
        .popover(isPresented: $viewModel.isPresentingPhotoPicker) {
            CMPhotoPicker(avatarItem: $viewModel.pickerItem)
        }
        .task(id: viewModel.pickerItem) {
            viewModel.handleReceivedPickerItem()
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
    }
}

#Preview {
    EditProfileView(myProfile: MockData.mockProfile(), navigationPath: .constant([.editProfile(MockData.mockProfile())]))
}
