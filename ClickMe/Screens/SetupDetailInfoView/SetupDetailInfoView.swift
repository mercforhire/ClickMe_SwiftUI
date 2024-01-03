//
//  SetupDetailInfoView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-03.
//

import SwiftUI
import PhotosUI

struct SetupDetailInfoView: View {
    @StateObject var viewModel: SetupDetailInfoViewModel = SetupDetailInfoViewModel()
    @FocusState private var focusedTextField: FormTextField?
    
    private let screenWidth = UIScreen.main.bounds.size.width
    private let padding: CGFloat = 25
    
    
    private enum FormTextField {
        case aboutMe
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Upload photos")) {
                    ProfilePhotosGridView(photos: $viewModel.userPhotos,
                                          width: screenWidth / 2 - padding * 2)
                    { index in
                        viewModel.handleDeletePhoto(index: index)
                    } handlePhotoPicker: {
                        viewModel.handlePhotoPicker()
                    }
                }
                
                Section(header: Text("About me")) {
                    TextEditor(text: $viewModel.aboutMe)
                        .foregroundStyle(.primary)
                        .focused($focusedTextField, equals: .aboutMe)
                        .frame(height: 200)
                        .keyboardType(.alphabet)
                }
                
                Section(header: Text("I speak")) {
                    MultiSelector(
                        label: Text("Languages"),
                        options: Language.list(),
                        optionToString: { $0.text() },
                        selected: $viewModel.languages
                    )
                }
                
                Spacer(minLength: 100)
            }
            .navigationTitle("Setup profile")
            .toolbar() {
                ToolbarItem(placement: .keyboard) {
                    Button("Done") {
                        focusedTextField = nil
                    }
                }
            }
            .toolbar() {
                Button("Done") {
                    
                }
            }
        }
//        .fullScreenCover(isPresented: $viewModel.isPresentingPhotoPicker) {
//            PhotosPicker(selection: $viewModel.avatarItem, matching: .images)
//        }
//        .onChange(of: viewModel.avatarItem) {
//            viewModel.handleReceivedAvatarItem()
//        }
    }
}

#Preview {
    let url = "https://media.licdn.com/dms/image/C5603AQFAiZ5E98oI1w/profile-displayphoto-shrink_200_200/0/1564032471373?e=1709769600&v=beta&t=xuD6QC1lVyhH5CVpT6GIdK_CZnm317WMp5xTnD-Du40"
    let photo = Photo(thumbnail: url, url: url)
    var vm = SetupDetailInfoViewModel()
    vm.userPhotos.append(photo)
    return SetupDetailInfoView(viewModel: vm)
}
