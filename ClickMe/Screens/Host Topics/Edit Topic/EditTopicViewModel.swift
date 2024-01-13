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
    
    @Published var description: String = ""
    @Published var descriptionError: String?
    
    @Published var maxTimeHours: Double = 1
    @Published var maxTimeHoursError: String?
    
    @Published var dollarPriceHour: Double = 0.0
    @Published var dollarPriceHourError: String?
    
    @Published var currency: Currency?
    @Published var currencyError: String?
    
    @Published var mood: Mood?
    @Published var moodError: String?
    
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
        
        guard maxTimeHours >= 1 && maxTimeHours <= 3 else {
            maxTimeHoursError = "Max length each session must be between 1 to 3 hours"
            return false
        }
        maxTimeHoursError = nil
        
        guard dollarPriceHour >= 0 && dollarPriceHour <= 50 else {
            dollarPriceHourError = "Price per hour should be from 0 to max of $50 a hour"
            return false
        }
        dollarPriceHourError = nil
        
        guard currency == nil else {
            currencyError = "Currency must be set"
            return false
        }
        currencyError = nil
        
        guard mood == nil else {
            moodError = "Please set the mood(category) of topic"
            return false
        }
        moodError = nil
        
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
        maxTimeHours = Double(topic.maxTimeMinutes) / 60
        dollarPriceHour = Double(topic.priceHour) / 100
        currency = topic.currency
        mood = topic.mood
    }
}
