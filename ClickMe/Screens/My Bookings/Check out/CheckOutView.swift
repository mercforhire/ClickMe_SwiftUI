//
//  CheckOutView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-15.
//

import SwiftUI
import StripePaymentSheet

struct CheckOutView: View {
    @StateObject var viewModel: CheckOutViewModel
    
    init(stripeData: StripeData) {
        _viewModel = StateObject(wrappedValue: CheckOutViewModel(stripeData: stripeData))
    }
    
    var body: some View {
        VStack {
            if let paymentSheet = viewModel.paymentSheet {
                PaymentSheet.PaymentButton(
                    paymentSheet: paymentSheet,
                    onCompletion: { result in
                        viewModel.onPaymentCompletion(result: result)
                    }
                ) {
                    Text("Buy")
                }
            } else {
                Text("Loading…")
            }
            if let result = viewModel.paymentResult {
                switch result {
                case .completed:
                    Text("Payment complete")
                case .failed(let error):
                    Text("Payment failed: \(error.localizedDescription)")
                case .canceled:
                    Text("Payment canceled.")
                }
            }
        }
        .onAppear {
            viewModel.preparePaymentSheet()
        }
        .navigationTitle("Check out")
    }
}

#Preview {
    CheckOutView(stripeData: StripeData(paymentIntentId: "pi_3OZGKWE0XSqZ8pU215jcEQaM", paymentIntentClientKey: "pi_3OZGKWE0XSqZ8pU215jcEQaM_secret_IoHlPUwDaWQyLF9IeADPMcofE", publishableKey: "pk_test_51ORj8NE0XSqZ8pU2SxzoZzSGury0c4sgKW8G6eme3gTMh1no9NTl1tymCxlJh3wlfb9SUZZDFCoIjYXqxkRMbNGr00MCoXrmDx"))
}
