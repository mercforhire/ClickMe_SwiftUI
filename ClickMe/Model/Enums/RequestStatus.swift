//
//  RequestStatus.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-08.
//

import Foundation
import SwiftUI

enum RequestStatus: String, Codable, Identifiable {
    case APPROVED
    case DECLINED
    case AWAITING_PAYMENT
    case PENDING_APPROVAL
    case CANCELLED
    case STARTED
    case FINISHED
    case EXPIRED
    case unknown
    
    var id: RequestStatus { self }
    
    func text() -> String {
        switch self {
        case .APPROVED:
            return "Approved"
        case .DECLINED:
            return "Declined"
        case .AWAITING_PAYMENT:
            return "Awaiting payment"
        case .PENDING_APPROVAL:
            return "Pending approval"
        case .STARTED:
            return "Started"
        case .CANCELLED:
            return "Cancelled"
        case .FINISHED:
            return "Finished"
        case .EXPIRED:
            return "Expired"
        case .unknown:
            return "Unknown"
        }
    }
}

extension RequestStatus {
    init(from decoder: Decoder) throws {
        self = try RequestStatus(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
    }
}
