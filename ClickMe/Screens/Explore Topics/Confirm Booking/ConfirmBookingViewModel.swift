//
//  ConfirmBookingViewModel.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-10.
//

import Foundation
import StripePaymentSheet

@MainActor
final class ConfirmBookingViewModel: ObservableObject {
    var topic: Topic
    var host: UserProfile
    var startTime: Date
    var endTime: Date
    
    @Published var isLoading = false
    @Published var currency: Currency?
    @Published var amount: Double?
    @Published var bookingError: String?
    @Published var bookingSuccess = false
    @Published var stripeData: StripeData?
    @Published var paymentSheet: PaymentSheet?
    
    var timeAndDuration: String {
        let date = DateUtil.convert(input: startTime, outputFormat: .format15)!
        let startTime = DateUtil.convert(input: startTime, outputFormat: .format8)!
        let endTime = DateUtil.convert(input: endTime, outputFormat: .format8)!
        return "\(date), \(startTime) - \(endTime)"
    }
    
    var displayablePrice: String {
        guard let amount, let currency else { return "" }
        
        if amount == 0 {
            return "FREE"
        }
        let dollarAmount: Double = Double(amount) / 100.0
        return "$\(String(format: "%.2f", dollarAmount)) \(currency.text())"
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
    
    func requestBooking() {
        isLoading = true
        Task {
            do {
                let params = RequestBookingParams(topicId: topic.id, startTime: startTime, endTime: endTime)
                let response = try await ClickAPI.shared.requestBooking(params: params)
                if response.success {
                    bookingError = nil
                    if let stripeData = response.data?.stripeData {
                        self.stripeData = stripeData
                        preparePaymentSheet()
                    } else {
                        bookingSuccess = true
                    }
                } else {
                    bookingError = "Unknown error"
                }
            } catch {
                switch error {
                case CMError.cantBookOwn:
                    bookingError = "Can't book own topic"
                case CMError.invalidBookingTime:
                    bookingError = "Invalid start and finish time"
                case CMError.bookingTimeTooLong:
                    bookingError = "Booking time exceeded topic's max allowed time"
                case CMError.invalidTimeSlot:
                    bookingError = "Time is not within host's time slots"
                case CMError.timeslotConflict:
                    bookingError = "Time is in conflict with an existing booking"
                default:
                    bookingError = "Unknown error"
                }
            }
            isLoading = false
        }
    }
    
    func preparePaymentSheet() {
        guard let stripeData else { return }
        
        STPAPIClient.shared.publishableKey = stripeData.publishableKey
        // MARK: Create a PaymentSheet instance
        var configuration = PaymentSheet.Configuration()
        configuration.merchantDisplayName = "Click Me"
        // Set `allowsDelayedPaymentMethods` to true if your business handles
        // delayed notification payment methods like US bank accounts.
        configuration.allowsDelayedPaymentMethods = true
        
        paymentSheet = PaymentSheet(paymentIntentClientSecret: stripeData.paymentIntentClientKey, configuration: configuration)
    }
    
    func onPaymentCompletion(result: PaymentSheetResult) {
        switch result {
        case .completed:
            bookingSuccess = true
        case .failed(let error):
            break
        case .canceled:
            break
        }
    }
}
