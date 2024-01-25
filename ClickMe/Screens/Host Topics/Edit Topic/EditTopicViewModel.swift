//
//  EditTopicViewModel.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-13.
//

import Foundation

@MainActor
final class EditTopicViewModel: ObservableObject {
    var myProfile: UserProfile
    var topic: Topic?
    
    @Published var isLoading = false
    
    @Published var title: String = ""
    @Published var titleError: String?
    
    @Published var keywords: [String] = []
    @Published var isShowingAddKeywordDialog = false
    @Published var newKeyword: String = ""
    @Published var addKeywordError: String?
    
    @Published var description: String = ""
    @Published var descriptionError: String?
    
    @Published var topicLength: TopicLengthChoice = .hour_2
    var maxTimeMinutes: Int {
        return topicLength.numberOfMins()
    }
    @Published var topicLengthError: String?
    
    @Published var dollarPriceHour: String = ""
    var centsPerHour: Int {
        Int((Double(dollarPriceHour) ?? 0) * 100)
    }
    @Published var dollarPriceHourError: String?
    
    @Published var currency: Currency = .USD
    
    @Published var mood: Mood = .other
    
    @Published var submissionComplete = false
    @Published var isShowingSubmissionErrorDialog = false
    @Published var submissionError: String?
    
    @Published var isShowingDeleteTopicDialog = false
    
    var isValidForm: Bool {
        guard !title.isEmpty else {
            titleError = "Title must be filled"
            return false
        }
        titleError = nil
        
        guard !description.isEmpty else {
            descriptionError = "Must be write a description"
            return false
        }
        descriptionError = nil
        
        guard !dollarPriceHour.isEmpty && centsPerHour >= 0 && centsPerHour <= 5000 else {
            dollarPriceHourError = "Price per hour should be from 0 to max of $50 a hour"
            return false
        }
        dollarPriceHourError = nil
        
        return true
    }
    
    init(myProfile: UserProfile, topic: Topic?) {
        self.myProfile = myProfile
        self.topic = topic
    }
    
    func initValues() {
        guard let topic else { return }
        
        title = topic.title
        keywords = topic.keywords
        description = topic.description
        topicLength = TopicLengthChoice.enumFromMinutes(minutes: topic.maxTimeMinutes)
        dollarPriceHour = String(format: "%.2f", Double(topic.priceHour) / 100)
        currency = topic.currency
        mood = topic.mood
    }
    
    func handleCreateTopic() {
        guard isValidForm else { return }
        
        isLoading = true
        Task {
            let params = CreateTopicParams(title: title,
                                           keywords: keywords,
                                           description: description,
                                           maxTimeMinutes: maxTimeMinutes,
                                           priceHour: centsPerHour,
                                           currency: currency,
                                           mood: mood)
            do {
                let response = try await ClickAPI.shared.createTopic(params: params)
                if response.success {
                    submissionError = nil
                    submissionComplete = true
                }
            } catch {
                submissionError = "Unknown error"
                submissionComplete = false
                isShowingSubmissionErrorDialog = true
            }
            isLoading = false
        }
    }
    
    func handleEditTopic() {
        guard isValidForm, let topic else { return }
        
        isLoading = true
        Task {
            let params = EditTopicParams(topicId: topic.id,
                                         title: title,
                                         keywords: keywords,
                                         description: description,
                                         maxTimeMinutes: maxTimeMinutes,
                                         priceHour: centsPerHour,
                                         currency: currency,
                                         mood: mood)
            do {
                let response = try await ClickAPI.shared.editTopic(params: params)
                if response.success {
                    submissionError = nil
                    submissionComplete = true
                }
            } catch {
                switch error {
                case CMError.topicDoesntExist:
                    submissionError = "Topic doesn't exist"
                case CMError.userIsNotTopicOwner:
                    submissionError = "User is not topic owner"
                default:
                    submissionError = "Unknown error"
                }
                submissionComplete = false
                isShowingSubmissionErrorDialog = true
            }
            isLoading = false
        }
    }
    
    func handleDeleteTopic() {
        guard isValidForm, let topic else { return }
        
        isLoading = true
        Task {
            do {
                let response = try await ClickAPI.shared.deleteTopic(topicId: topic._id)
                if response.success {
                    submissionError = nil
                    submissionComplete = true
                }
            } catch {
                switch error {
                case CMError.topicDoesntExist:
                    submissionError = "Topic doesn't exist"
                case CMError.userIsNotTopicOwner:
                    submissionError = "User is not topic owner"
                case CMError.topicHasOngoingBookings:
                    submissionError = "The topic has ongoing bookings"
                default:
                    submissionError = "Unknown error"
                }
                submissionComplete = false
                isShowingSubmissionErrorDialog = true
            }
            isLoading = false
        }
    }
    
    func handleAddNewKeyword() {
        if newKeyword.isEmpty {
            addKeywordError = "Type something to add it"
            return
        } else if keywords.contains(newKeyword) {
            addKeywordError = "Keywords already contain this word"
            return
        }
        
        addKeywordError = nil
        keywords.append(newKeyword.lowercased())
        newKeyword = ""
        isShowingAddKeywordDialog = false
    }
    
    func handleCancelAddNewKeyword() {
        newKeyword = ""
        isShowingAddKeywordDialog = false
    }
    
    func handleSaveButton() {
        if topic == nil {
            handleCreateTopic()
        } else {
            handleEditTopic()
        }
    }
}
