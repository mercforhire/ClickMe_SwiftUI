//
//  EditPhotosView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-09.
//

import SwiftUI
import PhotosUI

struct EditPhotosView: View {
    @Binding var isPresentingEditPhotosScreen: Bool
    @EnvironmentObject var viewModel: EditProfileViewModel
    
    private let screenWidth = UIScreen.main.bounds.size.width
    private let padding: CGFloat = 50
    private var photoCellWidth: CGFloat {
        return (screenWidth * 0.6)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Form {
                    Section(header: Text("Drag to reorder")) {
                        ForEach(viewModel.userPhotos, id: \.self) { photo in
                            HStack(alignment: .center) {
                                AsyncImage(url: URL(string: photo.thumbnail)) { image in
                                    image
                                    .resizable()
                                    .scaledToFill()
                                } placeholder: {
                                    Color.accentColor
                                }
                                .frame(width: photoCellWidth, height: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                
                                Spacer()
                                
                                Image(systemName: "line.3.horizontal")
                                    .resizable()
                                    .foregroundColor(.secondary)
                                    .frame(width: 25, height: 20)
                            }
                            .onDrag {
                                return NSItemProvider()
                            }
                        }
                        .onMove(perform: { source, Int in
                            viewModel.move(from: source, to: Int)
                        })
                        .onDelete { indexSet in
                            viewModel.handleDeletePhoto(at: indexSet)
                        }
                    }
                    
                    if let photosError = viewModel.photosError, !photosError.isEmpty {
                        CMErrorLabel(photosError)
                    }
                }
                
                if viewModel.isLoading {
                    LoadingView()
                }
            }
            .navigationTitle("Edit photos")
            .toolbar() {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button("Close") {
                        isPresentingEditPhotosScreen = false
                    }
                }
                
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("", systemImage: "plus") {
                        viewModel.handlePhotoPicker()
                    }
                }
            }
        }
        .alert(isPresented: $viewModel.s3UploadError) {
            Alert(title: Text("Upload error"),
                  message: Text("Something went wrong while uploading to S3"),
                  dismissButton: .default(Text("Ok")))
        }
        .photosPicker(isPresented: $viewModel.isPresentingPhotoPicker, selection: $viewModel.pickerItem)
        .task(id: viewModel.pickerItem) {
            viewModel.handleReceivedPickerItem()
        }
    }
}

#Preview {
    EditPhotosView(isPresentingEditPhotosScreen: .constant(true))
        .environmentObject({() -> EditProfileViewModel in
            let vm = EditProfileViewModel(myProfile: MockData.mockProfile())
            return vm
        }())
}
