//
//  Conversation.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-06.
//

import Foundation

struct Conversation: Codable, Identifiable {
    var id: String { return _id }
    
    let _id: String
    let createdDate: Date
    let participants: [UserProfile]
    let lastMessage: Message
    let lastMessageDate: Date
    
    static func mockConversation() -> Conversation {
        let participant1 = UserProfile(userId: "65971589d4f4d7af9f97a3bc", screenId: "d0rk4vpj9p", firstName: "Kayla", lastName: "Koch", city: "Melodyview", state: "Washington", country: .canada, jobTitle: "Regional Group Technician", company: "Larkin LLC", field: .science, degree: "Paradigm", aboutMe: "Curo dolores cornu demulceo distinctio cunae truculenter clibanus.", userPhotos: [Photo(thumbnail: "https://picsum.photos/id/122/255/300", url: "https://picsum.photos/id/914/344/259")], languages: [.french, .arabic, .vietnamese], numberOfFollowers: 6)
        
        let participant2 = UserProfile(userId: "65971717d4f4d7af9f97d93b", screenId: "xt2ta9wg5w", firstName: "Madaline", lastName: "Nikolaus", city: "Spinkastead", state: "Arkansas", country: .usa, jobTitle: "Legacy Intranet Technician", company: "Rau - Schaefer", field: .other, degree: "Metrics", aboutMe: "Validus eveniet aegrotatio curis deleniti amicitia aequitas.\nAnimi demo demulceo blanditiis uxor valde causa dedecor ago.\nSono ambitus audax.\nCorrumpo curo decens valetudo corrumpo.", userPhotos: [Photo(thumbnail: "https://picsum.photos/id/732/388/350", url: "https://picsum.photos/id/196/218/327")], languages: [.tagalog, .french], numberOfFollowers: 5)
        
        let lastMessage = Message(_id: "6599a83d5c1c5add1b703cb9", createdDate: Date(timeIntervalSince1970: 1704568600444 / 1000), fromUserId: "65971589d4f4d7af9f97a3bc", toUserId: "65971717d4f4d7af9f97d93b", message: "Hi Madaline", attachment: nil)
        
        return Conversation(_id: "6599a83d9cf78648273f8be4", createdDate: Date(timeIntervalSince1970: 1704568893224 / 1000), participants: [participant1, participant2], lastMessage: lastMessage, lastMessageDate: Date(timeIntervalSince1970: 1704568600444 / 1000))
    }
}
