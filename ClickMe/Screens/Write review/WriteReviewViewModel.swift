//
//  WriteReviewViewModel.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-12.
//

import Foundation

@MainActor
final class WriteReviewViewModel: ObservableObject {
    var reviewing: UserProfile
    var topic: Topic
    var request: Request
    
    @Published var rating = 3.0
    
    init(reviewing: UserProfile, topic: Topic, request: Request) {
        self.reviewing = reviewing
        self.topic = topic
        self.request = request
    }
}
