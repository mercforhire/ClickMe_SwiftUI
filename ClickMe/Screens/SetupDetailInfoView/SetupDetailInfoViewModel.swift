//
//  SetupDetailInfoViewModel.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-03.
//

import Foundation
import SwiftUI
import PhotosUI

final class SetupDetailInfoViewModel: ObservableObject {
    @Published var aboutMe = ""
    @Published var userPhotos: [Photo] = []
    @Published var languages: Set<Language> = [.english]
    @Published var isPresentingPhotoPicker = false
    @Published var avatarItem: PhotosPickerItem?
    @Published var avatarImage: Image?
    
    func handleDeletePhoto(index: Int) {
        print("handleDeletePhoto: ", index)
    }
    
    func handlePhotoPicker() {
        isPresentingPhotoPicker = true
    }
    
    func handleReceivedAvatarItem() {
        guard let avatarItem else { return }
        
        Task {
            if let loaded = try? await avatarItem.loadTransferable(type: Image.self) {
                avatarImage = loaded
                print("successfully loaded image")
            } else {
                print("failed to load image")
            }
        }
    }
}
