//
//  HostTopicsView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-11.
//

import SwiftUI

struct HostTopicsView: View {
    @StateObject var viewModel: HostTopicsViewModel
    @State private var navigationPath: [ScreenNames] = []
    
    init(myProfile: UserProfile) {
        _viewModel = StateObject(wrappedValue: HostTopicsViewModel(myProfile: myProfile))
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                List {
                    ForEach(viewModel.topics) { topic in
                        TopicView(topic: topic)
                            .listRowSeparator(.hidden)
                            .onTapGesture {
                                navigationPath.append(.editTopic(topic))
                            }
                    }
                }
                .listStyle(.plain)
                .refreshable {
                    viewModel.fetchTopics()
                }
                
                if viewModel.topics.isEmpty {
                    CMEmptyView(imageName: "empty", message: "You have no topics, please create one!")
                }
            }
            .navigationTitle("My topics")
            .toolbar() {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("", systemImage: "clock") {
                        navigationPath.append(.hostCalendar)
                    }
                    
                    Button("", systemImage: "plus") {
                        navigationPath.append(.editTopic(nil))
                    }
                }
            }
            .navigationDestination(for: ScreenNames.self) { screenName in
                switch screenName {
                case ScreenNames.editTopic(let topic):
                    EditTopicView(myProfile: viewModel.myProfile, topic: topic, navigationPath: $navigationPath)
                case ScreenNames.hostCalendar:
                    HostCalenderView(myProfile: viewModel.myProfile)
                default:
                    fatalError()
                }
            }
            .onAppear() {
                viewModel.fetchTopics()
            }
        }
    }
}

#Preview {
    ClickAPI.shared.apiKey = MockData.mockUser().apiKey
    return HostTopicsView(myProfile: MockData.mockProfile())
}
