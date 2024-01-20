//
//  WalletView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-18.
//

import SwiftUI

struct WalletView: View {
    @Binding private var navigationPath: [ScreenNames]
    @StateObject var viewModel: WalletViewModel
    
    init(myProfile: UserProfile, navigationPath: Binding<[ScreenNames]>) {
        _viewModel = StateObject(wrappedValue: WalletViewModel(myProfile: myProfile))
        self._navigationPath = navigationPath
    }
    
    var body: some View {
        Form {
            Section("Earnings") {
                HStack {
                    Text("Total expected:")
                        .font(.body)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text(viewModel.statistics?.totalEarningsDisplayable ?? "")
                        .font(.body)
                        .foregroundColor(.primary)
                }
                
                HStack {
                    Text("Upcoming:")
                        .font(.body)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text(viewModel.statistics?.totalEarningsDisplayable ?? "")
                        .font(.body)
                        .foregroundColor(.primary)
                }
                
                HStack {
                    Text("Paid out:")
                        .font(.body)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text(viewModel.statistics?.totalEarningsDisplayable ?? "")
                        .font(.body)
                        .foregroundColor(.primary)
                }
            }
            
            Section("Upcoming") {
                HStack {
                    Text("Date")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text("Amount before fee")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }
                if viewModel.upcoming.isEmpty {
                    Text("No upcoming payouts")
                        .font(.body)
                        .foregroundColor(.secondary)
                } else {
                    ForEach(viewModel.upcoming, id: \.self) { receipt in
                        ReceiptRowView(receipt: receipt)
                            .onTapGesture {
                                navigationPath.append(.receiptDetails(receipt))
                            }
                    }
                }
            }
            
            Section("Paid out") {
                HStack {
                    Text("Date")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text("Amount")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }
                if viewModel.paid.isEmpty {
                    Text("No completed payouts")
                        .font(.body)
                        .foregroundColor(.secondary)
                } else {
                    ForEach(viewModel.paid, id: \.self) { receipt in
                        ReceiptRowView(receipt: receipt)
                            .onTapGesture {
                                navigationPath.append(.receiptDetails(receipt))
                            }
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchData()
        }
        .navigationTitle("My wallet")
    }
}

#Preview {
    ClickAPI.shared.apiKey = MockData.mockUser2().apiKey
    return NavigationStack {
        WalletView(myProfile: MockData.mockProfile2(), navigationPath: .constant([]))
    }
}

struct ReceiptRowView: View {
    var receipt: Receipt
    
    var body: some View {
        HStack {
            Text(receipt.statusChangeDateDisplayable)
                .font(.body)
                .foregroundColor(.primary)
            
            Spacer()
            
            Text(receipt.amountDisplayable)
                .font(.body)
                .foregroundColor(.primary)
        }
    }
}
