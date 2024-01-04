//
//  SetupDetailInfoView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-03.
//

import SwiftUI

struct SetupDetailInfoView: View {
    let basicInfo: SetupBasicInfoViewModel
    @Binding var shouldPresentSetupProfileFlow: Bool
    @Binding var navigationPath: [ScreenNames]
    @StateObject var viewModel: SetupDetailInfoViewModel = SetupDetailInfoViewModel()
    
    private let screenWidth = UIScreen.main.bounds.size.width
    private let padding: CGFloat = 25
    private var photoCellWidth: CGFloat {
        return screenWidth / 2 - padding * 2
    }
    
    var body: some View {
        Form {
            Section(header: Text("Upload photos")) {
                ProfilePhotosGridView(photos: $viewModel.userPhotos,
                                      width: photoCellWidth)
                { index in
                    viewModel.handleDeletePhoto(index: index)
                } handlePhotoPicker: {
                    viewModel.handlePhotoPicker()
                }
                if let photosError = viewModel.photosError, !photosError.isEmpty {
                    CMErrorLabel(photosError)
                }
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
        .navigationTitle("Setup profile")
        .navigationBarTitleDisplayMode(.large)
        .toolbar() {
            Button("Done") {
                viewModel.updateProfile(basicInfo: basicInfo)
            }
        }
        .popover(isPresented: $viewModel.isPresentingPhotoPicker) {
            CMPhotoPicker(avatarItem: $viewModel.pickerItem)
        }
        .task(id: viewModel.pickerItem) {
            viewModel.handleReceivedPickerItem()
        }
        .alert(isPresented: $viewModel.s3UploadError) {
            Alert(title: Text("Upload error"),
                  message: Text("Something went wrong while uploading to S3"),
                  dismissButton: .default(Text("Ok")))
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
    var vm = SetupDetailInfoViewModel()
    return SetupDetailInfoView(basicInfo: SetupBasicInfoViewModel(), shouldPresentSetupProfileFlow: .constant(true), navigationPath: .constant([.setupDetailInfo]), viewModel: vm)
}
