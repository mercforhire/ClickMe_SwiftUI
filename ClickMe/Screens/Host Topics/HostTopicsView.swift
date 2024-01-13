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
                            .frame(height: 320)
                            .listRowSeparator(.hidden)
                            .onTapGesture {
                                navigationPath.append(.topicDetails(topic))
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
                    Button("", systemImage: "plus") {
                        
                    }
                }
            }
            .navigationDestination(for: ScreenNames.self) { screenName in
                switch screenName {
                case ScreenNames.topicDetails(let topic):
                    TopicDetailsView(topic: topic, navigationPath: $navigationPath)
                default:
                    fatalError()
                }
            }
        }
        .onAppear() {
            viewModel.fetchTopics()
        }
    }
}

#Preview {
    ClickAPI.shared.apiKey = MockData.mockUser2().apiKey
    return HostTopicsView(myProfile: MockData.mockProfile2())
}
