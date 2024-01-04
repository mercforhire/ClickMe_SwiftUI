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
    @Published var aboutMe = "I am an app maker."
    @Published var aboutMeError: String? = "test error"
    
    @Published var userPhotos: [Photo] = [Photo(thumbnail: "https://media.licdn.com/dms/image/C5603AQFAiZ5E98oI1w/profile-displayphoto-shrink_200_200/0/1564032471373?e=1709769600&v=beta&t=xuD6QC1lVyhH5CVpT6GIdK_CZnm317WMp5xTnD-Du40", url: "https://media.licdn.com/dms/image/C5603AQFAiZ5E98oI1w/profile-displayphoto-shrink_200_200/0/1564032471373?e=1709769600&v=beta&t=xuD6QC1lVyhH5CVpT6GIdK_CZnm317WMp5xTnD-Du40"), Photo(thumbnail: "https://s.yimg.com/ny/api/res/1.2/A4PCoWHj5cw7tn8oVqUoyg--/YXBwaWQ9aGlnaGxhbmRlcjt3PTk2MDtoPTU0MDtjZj13ZWJw/https://media.zenfs.com/en/bbc_us_articles_995/272abd221b73b25585194ec81b38e6ac", url: "https://s.yimg.com/ny/api/res/1.2/A4PCoWHj5cw7tn8oVqUoyg--/YXBwaWQ9aGlnaGxhbmRlcjt3PTk2MDtoPTU0MDtjZj13ZWJw/https://media.zenfs.com/en/bbc_us_articles_995/272abd221b73b25585194ec81b38e6ac")]
    @Published var photosError: String? = "test error"
    
    @Published var languages: Set<Language> = [.english, .chinese]
    @Published var languagesError: String? = "test error"
    
    @Published var isPresentingPhotoPicker = false
    @Published var pickerItem: PhotosPickerItem?
    @Published var s3UploadError = false
    @Published var updateProfileError = false
    
    var isValidForm: Bool {
        guard !aboutMe.isEmpty, aboutMe.count > 10 else {
            aboutMeError = "Write something about yourself(at least one sentence)"
            return false
        }
        aboutMeError = nil
        
        guard !userPhotos.isEmpty else {
            photosError = "Upload at least 1 photo"
            return false
        }
        photosError = nil
        
        guard !languages.isEmpty else {
            languagesError = "Pick at least 1 language"
            return false
        }
        languagesError = nil
        
        return true
    }
    
    func handleDeletePhoto(index: Int) {
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
        }
    }
    
    func handlePhotoPicker() {
        isPresentingPhotoPicker = true
    }
    
    func handleReceivedPickerItem() {
        guard let pickerItem else { return }
        
        Task {
            if let data = try? await pickerItem.loadTransferable(type: Data.self) {
                print("successfully loaded image")
                if let originalImage = UIImage(data: data), let userId = UserManager.shared.user?._id {
                    do {
                        if let photo = try await ClickAPI.shared.uploadPhoto(userId: userId, photo: originalImage) {
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
        }
    }
    
    func updateProfile(basicInfo: SetupBasicInfoViewModel) {
        guard isValidForm else { return }
        
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
                let response = try await ClickAPI.shared.updateUserProfile(updateProfileParams: updateProfileParams)
                if let profile = response.data?.profile {
                    UserManager.shared.set(profile: profile)
                }
            } catch {
                updateProfileError = true
            }
        }
    }
}
