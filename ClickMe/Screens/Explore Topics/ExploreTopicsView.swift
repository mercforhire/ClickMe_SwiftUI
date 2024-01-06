//
//  ExploreTopicsView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-06.
//

import SwiftUI

struct ExploreTopicsView: View {
    @StateObject var viewModel = ExploreTopicsViewModel()
    
    private let screenWidth = UIScreen.main.bounds.size.width
    private let padding: CGFloat = 40
    private var cellWidth: CGFloat {
        return screenWidth - padding * 2
    }
    private var moodCellWidth: CGFloat {
        return screenWidth / 2 - padding * 2
    }
    private let gridColumns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    ScrollView(.horizontal) {
                        LazyHGrid(rows: gridColumns) {
                            ForEach(Mood.list()) { mood in
                                MoodView(mood: mood, 
                                         width: moodCellWidth,
                                         height: 70,
                                         selected: viewModel.mood == mood)
                                .onTapGesture {
                                    viewModel.handleMoodClicked(mood: mood)
                                }
                            }
                        }
                        .frame(height: 150)
                        .padding(.horizontal, 20)
                    }
                    
                    if viewModel.topics.isEmpty {
                        CMEmptyView(imageName: "bad", message: "No topics of this category")
                    } else {
                        List(viewModel.topics, id: \.id) { topic in
                            TopicView(topic: topic, width: cellWidth, height: 250)
                                .onTapGesture {
                                    viewModel.selectedTopic = topic
                                    viewModel.isShowingTopic = true
                                }
                        }
                        .listStyle(.plain)
                        .refreshable {
                            viewModel.fetchTopics()
                        }
                    }
                }
            }
            .navigationTitle("Topics")
        }
        .onAppear() {
            viewModel.fetchTopics()
        }
        .fullScreenCover(isPresented: $viewModel.isShowingTopic) {
            if let topic = viewModel.selectedTopic {
                TopicDetailsView(topic: topic, isShowingTopic: $viewModel.isShowingTopic)
            }
        }
    }
}

#Preview {
    ClickAPI.shared.apiKey = "aeea2aee5e942ae7b2ce2618d9bce36b7d4f4cac868bf34df9bfd7dc2279acce69c03ca34570d42cc1a668e3aa7359a7784979938fead2052d31c6a110e94c7e"
    return ExploreTopicsView()
}
