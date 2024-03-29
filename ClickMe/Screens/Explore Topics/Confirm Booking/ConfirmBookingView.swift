//
//  ConfirmBookingView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-10.
//

import SwiftUI
import StripePaymentSheet

struct ConfirmBookingView: View {
    @StateObject var viewModel: ConfirmBookingViewModel
    @Binding var navigationPath: [ScreenNames]
    
    init(topic: Topic, host: UserProfile, startTime: Date, endTime: Date, navigationPath: Binding<[ScreenNames]>) {
        _viewModel = StateObject(wrappedValue: ConfirmBookingViewModel(topic: topic, host: host, startTime: startTime, endTime: endTime))
        self._navigationPath = navigationPath
    }
    
    var body: some View {
        ZStack {
            ScrollView(.vertical) {
                VStack(alignment: .leading) {
                    HStack(alignment: .center, spacing: 10) {
                        if let urlString = viewModel.host.avatarUrl {
                            AsyncImage(url: URL(string: urlString)) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                            } placeholder: {
                                Image("male-l", bundle: nil)
                                    .resizable()
                                    .scaledToFill()
                                    .opacity(0.5)
                            }
                            .frame(width: 80, height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .clipped()
                        }
                        
                        VStack(alignment: .leading) {
                            Text(viewModel.host.fullName)
                                .font(.body)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            Text(viewModel.host.jobTitle ?? "")
                                .font(.subheadline)
                                .foregroundColor(.primary)
                            
                            Text(viewModel.host.company ?? "")
                                .font(.subheadline)
                                .foregroundColor(.primary)
                        }
                    }
                    .padding(.all, 10)
                    
                    Divider()
                        .frame(height: 5)
                        .overlay(Color(.systemGray6))
                    
                    HStack {
                        Image(viewModel.topic.mood.imageName(), bundle: nil)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50, height: 50)
                        
                        Text("\(viewModel.topic.mood.text())")
                            .font(.title3)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                    }
                    .padding(.all, 10)
                    
                    Text(viewModel.topic.title)
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                    
                    Text(viewModel.topic.description)
                        .font(.body)
                        .fontWeight(.regular)
                        .foregroundColor(.primary)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                    
                    Text(viewModel.timeAndDuration)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Text(viewModel.displayablePrice)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Divider()
                        .frame(height: 5)
                        .overlay(Color(.systemGray6))
                    
                    if let bookingError = viewModel.bookingError {
                        CMErrorLabel(bookingError)
                            .padding(.horizontal, 10)
                    }
                    
                    if let paymentSheet = viewModel.paymentSheet {
                        PaymentSheet.PaymentButton(
                            paymentSheet: paymentSheet,
                            onCompletion: { result in
                                viewModel.onPaymentCompletion(result: result)
                            }
                        ) {
                            CMButton(title: "Complete prepayment", fullWidth: true)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.all, 10)
                        }
                    } else {
                        Button {
                            viewModel.requestBooking()
                        } label: {
                            CMButton(title: "Confirm")
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 20)
                    }
                }
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal, 20)
            }
            
            if viewModel.isLoading {
                LoadingView()
            }
        }
        .navigationTitle("Confirm booking")
        .background(Color(.systemGray6))
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.getPriceData()
        }
        .onChange(of: viewModel.bookingSuccess) { newValue in
            if viewModel.bookingSuccess {
                navigationPath.append(.bookingRequested)
                viewModel.bookingSuccess = false
            }
        }
    }
}

#Preview {
    ConfirmBookingView(topic: MockData.mockTopic(), host: MockData.mockProfile2(), startTime: Date(), endTime: Date().getPastOrFutureDate(hour: 1), navigationPath: .constant([]))
}
