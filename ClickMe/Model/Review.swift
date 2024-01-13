//
//  Review.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-12.
//

import Foundation

//{
//"_id": "65a1c46ae7775b49c5ff49b0",
//"createdDate": "2024-01-12T23:00:14.985Z",
//"reviewerId": "65971589d4f4d7af9f97a3bc",
//"revieweeId": "65971715d4f4d7af9f97d889",
//"requestId": "659bb0700c47d17cc781f078",
//"rating": 5,
//"comment": "good session",
//"reviewer": {
//    ...
//}
//}
struct Review: Codable, Identifiable, Hashable {
    var id: String { return _id }
    
    var _id: String
    var createdDate: Date
    var reviewerId: String
    var revieweeId: String
    var requestId: String
    var rating: Double
    var comment: String
    var reviewer: UserProfile?
}
