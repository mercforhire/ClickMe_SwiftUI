//
//  WriteReviewViewModel.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-12.
//

import Foundation

@MainActor
final class WriteReviewViewModel: ObservableObject {
    var myUserId: String
    var reviewing: UserProfile
    var topic: Topic
    var request: Request
    
    @Published var rating = 3.0
    @Published var writtenReview: String = ""
    @Published var isShowingCommentModal = false
    @Published var isLoading = false
    @Published var reviewSubmittionError: String?
    @Published var reviewSubmitSuccess = false
    
    init(myUserId: String, reviewing: UserProfile, topic: Topic, request: Request, existingReview: Review? = nil) {
        self.myUserId = myUserId
        self.reviewing = reviewing
        self.topic = topic
        self.request = request
        
        if let existingReview {
            rating = existingReview.rating
            writtenReview = existingReview.comment
        }
    }
    
    func submitReview() {
        guard !writtenReview.isEmpty else {
            reviewSubmittionError = "Review must not be empty"
            return
        }
        reviewSubmittionError = nil
        
        isLoading = true
        Task {
            do {
                let response = try await ClickAPI.shared.submitReview(revieweeId: reviewing.userId, requestId: request._id, rating: rating, comment: writtenReview)
                if response.success {
                    reviewSubmittionError = nil
                    reviewSubmitSuccess = true
                } else {
                    reviewSubmittionError = "Unknown error"
                }
            } catch {
                switch error {
                case CMError.bookingRequestMustBeFinished:
                    reviewSubmittionError = "Booking request must be finished before can be reviewed"
                case CMError.userIsNotInTheBooking:
                    reviewSubmittionError = "You are not a participant in this booking session"
                case CMError.bookingTimeTooLong:
                    reviewSubmittionError = "Booking time exceeded topic's max allowed time"
                case CMError.canNotReviewSelf:
                    reviewSubmittionError = "Can't not review yourself (this is a bug)"
                case CMError.invalidData:
                    reviewSubmittionError = "Invalid rating number (this is a bug)"
                case CMError.reviewMustContainComment:
                    reviewSubmittionError = "Ccomment must not be empty"
                default:
                    reviewSubmittionError = "Unknown error"
                }
            }
            isLoading = false
        }
    }
}
