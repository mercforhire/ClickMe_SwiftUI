//
//  CheckOutViewModel.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-15.
//

import StripePaymentSheet
import SwiftUI

class CheckOutViewModel: ObservableObject {
    var stripeData: StripeData
    
    @Published var paymentSheet: PaymentSheet?
    @Published var paymentResult: PaymentSheetResult?
    
    init(stripeData: StripeData) {
        self.stripeData = stripeData
    }
    
    func preparePaymentSheet() {
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
        self.paymentResult = result
    }
}
