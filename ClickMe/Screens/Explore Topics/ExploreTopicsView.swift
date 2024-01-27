//
//  ExploreTopicsView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-06.
//

import SwiftUI

struct ExploreTopicsView: View {
    @Binding var openTopic: Topic?
    @StateObject var viewModel = ExploreTopicsViewModel()
    @State private var navigationPath: [ScreenNames] = []
    
    private let screenWidth = UIScreen.main.bounds.size.width
    private let screenHeight = UIScreen.main.bounds.size.height
    private let padding: CGFloat = 40
    private var cellWidth: CGFloat {
        return screenWidth - padding * 2
    }
    private var moodCellWidth: CGFloat {
        return (screenWidth - padding * 5) / 2
    }
    private let gridColumns: [GridItem] = [GridItem(.flexible())]
    
    init(openTopic: Binding<Topic?>) {
        self._openTopic = openTopic
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                List {
                    ScrollView(.horizontal) {
                        LazyHGrid(rows: gridColumns) {
                            ForEach(Mood.allCases) { mood in
                                MoodView(mood: mood,
                                         width: moodCellWidth,
                                         height: 70,
                                         selected: viewModel.mood == mood)
                                .onTapGesture {
                                    viewModel.handleMoodClicked(mood: mood)
                                }
                            }
                        }
                    }
                    .listRowSeparator(.hidden)
                    
                    if viewModel.topics.isEmpty {
                        CMEmptyView(imageName: "bad",
                                    message: "No topics of this category")
                        .padding(.top, screenHeight * 0.1)
                    } else {
                        ForEach(viewModel.topics) { topic in
                            TopicView(topic: topic)
                                .frame(height: 320)
                                .listRowSeparator(.hidden)
                                .onTapGesture {
                                    navigationPath.append(.topicDetails(topic))
                                }
                        }
                    }
                }
                .listStyle(.plain)
                .refreshable {
                    viewModel.fetchTopics()
                }
                
                
            }
            .navigationTitle("Topics")
            .navigationDestination(for: ScreenNames.self) { screenName in
                switch screenName {
                case ScreenNames.topicDetails(let topic):
                    TopicDetailsView(topic: topic, navigationPath: $navigationPath)
                case ScreenNames.selectTime(let topic, let host):
                    SelectTimeView(topic: topic, host: host, navigationPath: $navigationPath)
                case ScreenNames.confirmBooking(let topic, let host, let startTime, let endTime):
                    ConfirmBookingView(topic: topic, host: host, startTime: startTime, endTime: endTime, navigationPath: $navigationPath)
                case ScreenNames.bookingRequested:
                    BookingRequestedView(navigationPath: $navigationPath)
                case ScreenNames.followingTopics:
                    FollowingTopicsView(navigationPath: $navigationPath)
                default:
                    fatalError()
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("", systemImage: "heart") {
                        navigationPath.append(.followingTopics)
                    }
                    .tint(Color.accentColor)
                }
            }
            .onChange(of: openTopic) { topic in
                if let topic {
                    navigationPath.removeAll()
                    navigationPath.append(.topicDetails(topic))
                }
            }
        }
        .onAppear() {
            viewModel.fetchTopics()
            
            if viewModel.firstTime, let openTopic = openTopic {
                navigationPath.append(.topicDetails(openTopic))
            }
            viewModel.firstTime = false
        }
    }
}

#Preview {
    ClickAPI.shared.apiKey = MockData.mockUser().apiKey
    return ExploreTopicsView(openTopic: .constant(nil))
}
