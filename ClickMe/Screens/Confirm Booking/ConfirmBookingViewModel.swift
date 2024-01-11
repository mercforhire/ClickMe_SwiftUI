//
//  ConfirmBookingViewModel.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-10.
//

import Foundation

@MainActor
final class ConfirmBookingViewModel: ObservableObject {
    var topic: Topic
    var host: UserProfile
    var startTime: Date
    var endTime: Date
    
    @Published var isLoading = false
    @Published var currency: Currency?
    @Published var amount: Double?
    
    var displayablePrice: String {
        guard let amount, let currency else { return "" }
        
        if amount == 0 {
            return "FREE"
        }
        let dollarAmount: Double = Double(amount) / 100.0
        return "\(dollarAmount.formatted(.currency(code: currency.rawValue)))"
    }
    
    init(topic: Topic, host: UserProfile, startTime: Date, endTime: Date) {
        self.host = host
        self.topic = topic
        self.startTime = startTime
        self.endTime = endTime
    }
    
    func getPriceData() {
        isLoading = true
        Task {
            let params = RequestBookingParams(topicId: topic.id, startTime: startTime, endTime: endTime)
            let response = try? await ClickAPI.shared.getBookingPrice(params: params)
            if let data = response?.data {
                self.currency = data.currency
                self.amount = data.amount
            }
            isLoading = false
        }
    }
}
