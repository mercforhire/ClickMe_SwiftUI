//
//  HostStatusView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-11.
//

import SwiftUI

struct HostStatusView: View {
    @StateObject var viewModel: HostStatusViewModel
    @State private var navigationPath: [ScreenNames] = []
    
    init(myProfile: UserProfile) {
        _viewModel = StateObject(wrappedValue: HostStatusViewModel(myProfile: myProfile))
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ScrollView(.vertical) {
                VStack(alignment: .leading) {
                    Text("Earnings")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color(.systemYellow))
                        .padding(.top, 20)
                        .padding(.horizontal, 20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack(alignment: .center, spacing: 30) {
                        VStack(spacing: 5) {
                            Text("Total")
                                .font(.title3)
                                .fontWeight(.medium)
                                .foregroundColor(.primary)
                            
                            Image("recharge", bundle: nil)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 120)
                                .padding(.horizontal, 10)
                            
                            Text(viewModel.statistics?.totalEarningsDisplayable ?? "")
                                .font(.title3)
                                .fontWeight(.medium)
                                .foregroundColor(Color.accentColor)
                            
                        }
                        .padding(.all, 5)
                        .background(Color(.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        
                        VStack(spacing: 5) {
                            Text("Hours")
                                .font(.title3)
                                .fontWeight(.medium)
                                .foregroundColor(.primary)
                            
                            Image("event", bundle: nil)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 120)
                                .padding(.horizontal, 10)
                            
                            Text("\(viewModel.statistics?.totalHours ?? 0)")
                                .font(.title3)
                                .fontWeight(.medium)
                                .foregroundColor(.accentColor)
                            
                        }
                        .padding(.all, 5)
                        .background(Color(.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                    }
                    .padding(.all, 20)
                    .frame(height: 200)
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
                
                VStack(alignment: .leading) {
                    Text("Reviews")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color(.systemYellow))
                        .padding(.top, 20)
                        .padding(.horizontal, 20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack(alignment: .center, spacing: 30) {
                        VStack(spacing: 5) {
                            Text("\(viewModel.statistics?.numberOfReviews ?? 0)")
                                .font(.title)
                                .fontWeight(.medium)
                                .foregroundColor(.accentColor)
                            
                            Text("Total reviews")
                                .font(.body)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
                        }
                        .padding(.all, 5)
                        .frame(width: 140, height: 150)
                        .background(Color(.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .onTapGesture {
                            navigationPath.append(.reviews(viewModel.myProfile))
                        }
                        
                        VStack(spacing: 5) {
                            Text(viewModel.statistics?.ratingDisplayable ?? "")
                                .font(.title)
                                .fontWeight(.medium)
                                .foregroundColor(.accentColor)
                            
                            Text("Overall rating")
                                .font(.body)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
                        }
                        .padding(.all, 5)
                        .frame(width: 120, height: 150)
                        .background(Color(.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                    }
                    .padding(.all, 20)
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .padding(.horizontal, 20)
            }
            .onAppear {
                viewModel.fetchData()
            }
            .navigationTitle("Hosting status")
            .navigationDestination(for: ScreenNames.self) { screenName in
                switch screenName {
                case ScreenNames.reviews(let user):
                    ReviewsView(user: user)
                default:
                    fatalError()
                }
            }
        }
    }
}

#Preview {
    ClickAPI.shared.apiKey = MockData.mockUser2().apiKey
    return HostStatusView(myProfile: MockData.mockProfile2())
}
