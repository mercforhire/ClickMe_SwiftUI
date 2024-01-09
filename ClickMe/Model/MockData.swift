//
//  MockData.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-07.
//

import Foundation

class MockData {
    static func mockPhoto() -> Photo {
        Photo(thumbnail: "https://picsum.photos/id/524/300/500", url: "https://picsum.photos/id/524/300/500")
    }
    
    static func mockProfile() -> UserProfile {
        return UserProfile(userId: "65971589d4f4d7af9f97a3bc", screenId: "d0rk4vpj9p", firstName: "Kayla", lastName: "Koch", city: "Melodyview", state: "Washington", country: .canada, jobTitle: "Regional Group Technician", company: "Larkin LLC", field: .science, degree: "Paradigm", aboutMe: "Curo dolores cornu demulceo distinctio cunae truculenter clibanus.", userPhotos: [MockData.mockPhoto(), MockData.mockPhoto(), MockData.mockPhoto()], languages: [.english, .french], numberOfFollowers: 55)
    }
    
    static func mockProfile2() -> UserProfile {
        return UserProfile(userId: "65971715d4f4d7af9f97d889", screenId: "0a6wb8asjp", firstName: "Reva", lastName: "Cormier", city: "Ephraimchester", state: "West Virginia", country: .usa, jobTitle: "Lead Response Administrator", company: "Fritsch, Lehner and Klein", field: .social, degree: "Communications", aboutMe: "Apparatus desipio adfectus tripudio super solvo utroque amor perspiciatis earum.", userPhotos: [MockData.mockPhoto(), MockData.mockPhoto(), MockData.mockPhoto()], languages: [.english], numberOfFollowers: 55)
    }
    
    static func mockShortMessage() -> Message {
        return Message(_id: "6599a83d5c1c5add1b703cb9", createdDate: Date(timeIntervalSince1970: 1704568600444 / 1000), fromUserId: "65971589d4f4d7af9f97a3bc", toUserId: "65971717d4f4d7af9f97d93b", message: "Hi Madaline", attachment: nil)
    }
    
    static func mockLongMessage() -> Message {
        return Message(_id: "6599a83d5c1c5add1b703cb9",
                       createdDate: Date(timeIntervalSince1970: 1704568600444 / 1000),
                       fromUserId: "65971589d4f4d7af9f97a3bc",
                       toUserId: "65971717d4f4d7af9f97d93b",
                       message: "Paragraphs are the building blocks of papers. Many students define paragraphs in terms of length: a paragraph is a group of at least five sentences, a paragraph is half a page long, etc. In reality, though, the unity and coherence of ideas among sentences is what constitutes a paragraph. A paragraph is defined as “a group of sentences or a single sentence that forms a unit” (Lunsford and Connors 116). Length and appearance do not determine whether a section in a paper is a paragraph. For instance, in some styles of writing, particularly journalistic styles, a paragraph can be just one sentence long. Ultimately, a paragraph is a sentence or group of sentences that support one main idea. In this handout, we will refer to this as the “controlling idea,” because it controls what happens in the rest of the paragraph.",
                       attachment: nil)
    }
    
    static func mockConversation() -> Conversation {
        let participant1 = UserProfile(userId: "65971589d4f4d7af9f97a3bc", screenId: "d0rk4vpj9p", firstName: "Kayla", lastName: "Koch", city: "Melodyview", state: "Washington", country: .canada, jobTitle: "Regional Group Technician", company: "Larkin LLC", field: .science, degree: "Paradigm", aboutMe: "Curo dolores cornu demulceo distinctio cunae truculenter clibanus.", userPhotos: [Photo(thumbnail: "https://picsum.photos/id/122/255/300", url: "https://picsum.photos/id/914/344/259")], languages: [.french, .arabic, .vietnamese], numberOfFollowers: 6)
        
        let participant2 = UserProfile(userId: "65971717d4f4d7af9f97d93b", screenId: "xt2ta9wg5w", firstName: "Madaline", lastName: "Nikolaus", city: "Spinkastead", state: "Arkansas", country: .usa, jobTitle: "Legacy Intranet Technician", company: "Rau - Schaefer", field: .other, degree: "Metrics", aboutMe: "Validus eveniet aegrotatio curis deleniti amicitia aequitas.\nAnimi demo demulceo blanditiis uxor valde causa dedecor ago.\nSono ambitus audax.\nCorrumpo curo decens valetudo corrumpo.", userPhotos: [Photo(thumbnail: "https://picsum.photos/id/732/388/350", url: "https://picsum.photos/id/196/218/327")], languages: [.tagalog, .french], numberOfFollowers: 5)
        
        let lastMessage = Message(_id: "6599a83d5c1c5add1b703cb9", createdDate: Date(timeIntervalSince1970: 1704568600444 / 1000), fromUserId: "65971589d4f4d7af9f97a3bc", toUserId: "65971717d4f4d7af9f97d93b", message: "Hi Madaline", attachment: nil)
        
        return Conversation(_id: "6599a83d9cf78648273f8be4", createdDate: Date(timeIntervalSince1970: 1704568893224 / 1000), participants: [participant1, participant2], lastMessage: lastMessage, lastMessageDate: Date(timeIntervalSince1970: 1704568600444 / 1000))
    }
    
    static func mockTopic() -> Topic {
        return Topic(_id: "6597179f748b7b670290b52d", userId: "6597171ad4f4d7af9f97da76", title: "Thesis vere decretum animi iure vilitas. ", keywords: ["startup", "advice"], description: "Libero repudiandae cohibeo a caelestis. Expedita testimonium contego. Contigo degusto admiratio vilitas demergo comitatus ut apud facere annus.", maxTimeMinutes: 180, priceHour: 2000, currency: .USD, mood: .startup, userProfile: MockData.mockProfile())
    }
    
    static func mockRequest() -> Request {
        return Request(_id: "659bb0700c47d17cc781f078", createdDate: Date(timeIntervalSince1970: 1704568893224 / 1000), bookingUserId: "65971589d4f4d7af9f97a3bc", bookingUser: MockData.mockProfile(), hostUserId: "65971715d4f4d7af9f97d889", hostUser: MockData.mockProfile2(), topicId: "659adae17a68168153de39e2", topic: MockData.mockTopic(), startTime: Date(timeIntervalSince1970: 1704449058905 / 1000), endTime: Date(timeIntervalSince1970: 1704470549714 / 1000), status: .PENDING_APPROVAL)
    }
    
    static func mockReceipt() -> Receipt {
        return Receipt(_id: "659c46599cf786482795c34b", createdDate: Date(timeIntervalSince1970: 1704568893224 / 1000), paymentIntentId: "pi_3OWO3wE0XSqZ8pU20SZchr6c", booker: MockData.mockProfile(), host: MockData.mockProfile2(), topic: MockData.mockTopic(), requestId: "659bb0700c47d17cc781f078", request: MockData.mockRequest(), status: .UNPAID, amount: 2000, currency: .USD)
    }
}
