//
//  SetupDetailInfoView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-03.
//

import SwiftUI
import PhotosUI

struct SetupDetailInfoView: View {
    var basicInfo: SetupBasicInfoViewModel
    @Binding var shouldPresentSetupProfileFlow: Bool
    @Binding var navigationPath: [ScreenNames]
    @StateObject var viewModel: SetupDetailInfoViewModel
    
    private let screenWidth = UIScreen.main.bounds.size.width
    private let padding: CGFloat = 40
    private var photoCellWidth: CGFloat {
        return (screenWidth - padding * 2) / 2
    }
    private let gridMatrix: [GridItem] = [GridItem(.flexible()), GridItem(.flexible())]
    
    init(myProfile: UserProfile,
         basicInfo: SetupBasicInfoViewModel,
         shouldPresentSetupProfileFlow: Binding<Bool>,
         navigationPath: Binding<[ScreenNames]>) {
        self.basicInfo = basicInfo
        _shouldPresentSetupProfileFlow = shouldPresentSetupProfileFlow
        _navigationPath = navigationPath
        _viewModel = StateObject(wrappedValue: SetupDetailInfoViewModel(myProfile: myProfile))
    }
    
    var body: some View {
        ZStack {
            Form {
                Section(header: Text("Upload photos")) {
                    ProfilePhotosGridView(photos: $viewModel.userPhotos,
                                          width: photoCellWidth,
                                          maxPhotos: 4,
                                          gridMatrix: gridMatrix)
                    { index in
                        viewModel.handleDeletePhoto(index: index)
                    } handlePhotoPicker: {
                        viewModel.handlePhotoPicker()
                    }
                    
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
            
            if viewModel.isLoading {
                LoadingView()
            }
        }
        .navigationTitle("Setup profile")
        .navigationBarTitleDisplayMode(.large)
        .toolbar() {
            Button("Done") {
                viewModel.updateProfile(basicInfo: basicInfo)
            }
        }
        .photosPicker(isPresented: $viewModel.isPresentingPhotoPicker, selection: $viewModel.pickerItem)
        .task(id: viewModel.pickerItem) {
            viewModel.handleReceivedPickerItem()
        }
        .alert(isPresented: $viewModel.updateProfileError) {
            Alert(title: Text("Server error"),
                  message: Text("Something went wrong while updating profile"),
                  dismissButton: .default(Text("Ok")))
        }
        .onChange(of: viewModel.updateProfileFinished) { updateProfileFinished in
            if updateProfileFinished {
                shouldPresentSetupProfileFlow = false
            }
        }
    }
}

#Preview {
    ClickAPI.shared.apiKey = MockData.mockUser().apiKey
    return SetupDetailInfoView(myProfile: MockData.mockProfile(),
                               basicInfo: SetupBasicInfoViewModel(myProfile: MockData.mockProfile()),
                               shouldPresentSetupProfileFlow: .constant(true),
                               navigationPath: .constant([]))
}
