//
//  SetupDetailInfoViewModel.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-03.
//

import Foundation
import SwiftUI
import PhotosUI

@MainActor
final class SetupDetailInfoViewModel: ObservableObject {
    var myProfile: UserProfile
    
    @Published var aboutMe = ""
    @Published var aboutMeError: String?
    
    @Published var userPhotos: [Photo] = []
    @Published var photosError: String?
    
    @Published var languages: Set<Language> = []
    @Published var languagesError: String?
    
    @Published var isPresentingPhotoPicker = false
    @Published var pickerItem: PhotosPickerItem?
    @Published var s3UploadError = false
    @Published var updateProfileError = false
    @Published var updateProfileFinished = false
    @Published var isLoading = false
    
    var isValidForm: Bool {
        guard !userPhotos.isEmpty else {
            photosError = "Upload at least 1 photo"
            return false
        }
        photosError = nil
        
        guard !aboutMe.isEmpty, aboutMe.count > 10 else {
            aboutMeError = "Write something about yourself(at least one sentence)"
            return false
        }
        aboutMeError = nil
        
        guard !languages.isEmpty else {
            languagesError = "Pick at least 1 language"
            return false
        }
        languagesError = nil
        
        return true
    }
    
    init(myProfile: UserProfile) {
        self.myProfile = myProfile
    }
    
    func handleDeletePhoto(index: Int) {
        isLoading = true
        Task {
            let photo = userPhotos[index]
            do {
                try await ClickAPI.shared.deleteS3file(fileURL: photo.thumbnail)
                try await ClickAPI.shared.deleteS3file(fileURL: photo.url)
            } catch {
                switch error {
                case CMError.s3UploadFailed:
                    s3UploadError = true
                default:
                    print(error)
                }
            }
            userPhotos.remove(at: index)
            isLoading = false
        }
    }
    
    func handlePhotoPicker() {
        isPresentingPhotoPicker = true
    }
    
    func handleReceivedPickerItem() {
        guard let pickerItem else { return }
        
        isLoading = true
        Task {
            if let data = try? await pickerItem.loadTransferable(type: Data.self) {
                print("successfully loaded image")
                if let originalImage = UIImage(data: data) {
                    do {
                        if let photo = try await ClickAPI.shared.uploadPhoto(userId: myProfile.userId, photo: originalImage) {
                            userPhotos.append(photo)
                            isPresentingPhotoPicker = false
                        }
                    } catch {
                        switch error {
                        case CMError.s3UploadFailed:
                            s3UploadError = true
                        default:
                            break
                        }
                    }
                }
            } else {
                print("failed to load image")
            }
            isLoading = false
        }
    }
    
    func updateProfile(basicInfo: SetupBasicInfoViewModel) {
        guard isValidForm else { return }
        
        isLoading = true
        Task {
            let updateProfileParams = UpdateProfileParams(firstName: basicInfo.firstName,
                                                          lastName: basicInfo.lastName,
                                                          city: basicInfo.city,
                                                          state: basicInfo.state,
                                                          country: basicInfo.country,
                                                          jobTitle: basicInfo.jobTitle,
                                                          company: basicInfo.company,
                                                          field: basicInfo.field,
                                                          degree: basicInfo.degree,
                                                          aboutMe: aboutMe,
                                                          userPhotos: userPhotos,
                                                          languages: Array(languages))
            do {
                let response = try await ClickAPI.shared.updateUserProfile(params: updateProfileParams)
                if let profile = response.data?.profile {
                    UserManager.shared.set(profile: profile)
                    updateProfileFinished = true
                }
            } catch {
                updateProfileError = true
            }
        }
        isLoading = false
    }
}
