//
//  Message.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-06.
//

import Foundation

struct Message: Codable, Identifiable, Hashable {
    var id: String { return _id }
    
    let _id: String
    let createdDate: Date
    let fromUserId: String
    let toUserId: String
    let message: String?
    let attachment: Attachment?
    
    func getDisplayMessage(participants: [UserProfile]) -> String {
        if !(message?.isEmpty ?? true) {
            return message ?? ""
        }
        
        if let attachment = attachment, let request = attachment.request, let topic = attachment.topic {
            switch attachment.action {
            case .BOOKING_ATTEMPT:
                if let booker = UserProfile.getUser(from: participants, of: request.bookingUserId) {
                    return "\(booker.firstName ?? "") has made an attempt to book topic: \(topic.title) on \(request.timeAndDuration)"
                }
            case .BOOKING_REQUEST:
                if let booker = UserProfile.getUser(from: participants, of: request.bookingUserId) {
                    return "\(booker.firstName ?? "") has made a request to book topic: \(topic.title) on \(request.timeAndDuration)"
                }
            case .APPROVED:
                if let host = UserProfile.getUser(from: participants, of: request.hostUserId) {
                    return "\(host.firstName ?? "") has approved the request to book topic: \(topic.title) on \(request.timeAndDuration)"
                }
            case .DECLINED:
                if let host = UserProfile.getUser(from: participants, of: request.hostUserId) {
                    return "\(host.firstName ?? "") has declined the request to book topic: \(topic.title) on \(request.timeAndDuration)"
                }
            case .CANCEL:
                return "Booking \(request.timeAndDuration) of topic: \(topic.title) has been cancelled"
            case .unknown:
                break
            }
        }
            
        return ""
    }
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        lhs._id == rhs._id
    }
    
}
