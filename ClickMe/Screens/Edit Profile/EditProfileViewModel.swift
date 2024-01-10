//
//  EditProfileViewModel.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-09.
//

import Foundation
import SwiftUI
import PhotosUI

@MainActor
final class EditProfileViewModel: ObservableObject {
    @Published var myProfile: UserProfile
    @Published var isLoading = false
    
    @Published var firstName = ""
    @Published var firstNameError: String?
    @Published var lastName = ""
    @Published var lastNameError: String?
    @Published var city = ""
    @Published var state = ""
    @Published var country: Country = .canada
    @Published var jobTitle = ""
    @Published var company = ""
    @Published var field: Field = .tech
    @Published var degree = ""
    
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
    
    @Published var photosToDelete: [Photo] = []
    @Published var isPresentingEditPhotosScreen = false
    
    var isValidForm: Bool {
        guard !firstName.isEmpty else {
            firstNameError = "First name must be filled"
            return false
        }
        firstNameError = nil
        
        guard !lastName.isEmpty else {
            lastNameError = "Last name must be filled"
            return false
        }
        lastNameError = nil
        
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
        initValues()
    }
    
    func initValues() {
        firstName = myProfile.firstName ?? ""
        lastName = myProfile.lastName ?? ""
        city = myProfile.city ?? ""
        state = myProfile.state ?? ""
        country = myProfile.country ?? .canada
        jobTitle = myProfile.jobTitle ?? ""
        field = myProfile.field ?? .other
        company = myProfile.company ?? ""
        degree = myProfile.degree ?? ""
        aboutMe = myProfile.aboutMe ?? ""
        userPhotos = myProfile.userPhotos ?? []
        languages = Set(myProfile.languages ?? [])
    }
    
    func move(from source: IndexSet, to destination: Int) {
        userPhotos.move(fromOffsets: source, toOffset: destination )
    }
    
    func handleDeletePhoto(at offsets: IndexSet) {
        if userPhotos.count <= 1 {
            photosError = "Can't not delete the last photo"
            return
        }
        
        offsets.forEach { index in
            let photo = userPhotos[index]
            // instead of deleting from AWS S3 right away, add the photo to photosToDelete,
            // only delete them from server AFTER the profile is saved
            photosToDelete.append(photo)
        }
        userPhotos.remove(atOffsets: offsets)
    }
    
    func handlePhotoPicker() {
        if userPhotos.count >= 9 {
            photosError = "Can't have more than 9 photos"
            return
        }
        
        isPresentingPhotoPicker = true
    }
    
    func handleReceivedPickerItem() {
        guard let pickerItem else { return }
        
        Task {
            if let data = try? await pickerItem.loadTransferable(type: Data.self) {
                print("successfully loaded image")
                if let originalImage = UIImage(data: data), let userId = UserManager.shared.user?._id {
                    isLoading = true
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
                    isLoading = false
                }
            } else {
                print("failed to load image")
            }
        }
    }
    
    func handleSaveAction() {
        guard isValidForm else { return }
        
        Task {
            await updateProfile()
            if updateProfileError {
                return
            }
            
            await deleteAllPhotos()
            updateProfileFinished = true
        }
    }
    
    func updateProfile() async {
        let updateProfileParams = UpdateProfileParams(firstName: firstName,
                                                      lastName: lastName,
                                                      city: city,
                                                      state: state,
                                                      country: country,
                                                      jobTitle: jobTitle,
                                                      company: company,
                                                      field: field,
                                                      degree: degree,
                                                      aboutMe: aboutMe,
                                                      userPhotos: userPhotos,
                                                      languages: Array(languages))
        do {
            let response = try await ClickAPI.shared.updateUserProfile(params: updateProfileParams)
            if let profile = response.data?.profile {
                UserManager.shared.set(profile: profile)
            }
        } catch {
            updateProfileError = true
        }
    }
    
    func deleteAllPhotos() async {
        for photo in photosToDelete {
            do {
                try await ClickAPI.shared.deleteS3file(fileURL: photo.thumbnail)
                try await ClickAPI.shared.deleteS3file(fileURL: photo.url)
            } catch {
                print(error)
            }
        }
    }
}
