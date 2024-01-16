//
//  FollowingTopicsView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-16.
//

import SwiftUI

struct FollowingTopicsView: View {
    @StateObject var viewModel = FollowingTopicsViewModel()
    @Binding var navigationPath: [ScreenNames]
    
    init(navigationPath: Binding<[ScreenNames]>) {
        self._navigationPath = navigationPath
    }
    
    var body: some View {
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
                CMEmptyView(imageName: "bad", message: "No following user's topics")
            }
            
            if viewModel.isLoading {
                LoadingView()
            }
        }
        .navigationTitle("Following users topics")
        .onAppear() {
            viewModel.fetchTopics()
        }
    }
}

#Preview {
    FollowingTopicsView(navigationPath: .constant([]))
}
