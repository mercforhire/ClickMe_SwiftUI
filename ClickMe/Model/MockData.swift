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
    
    static func mockPhoto1() -> Photo {
        Photo(thumbnail: "https://picsum.photos/id/525/300/500", url: "https://picsum.photos/id/525/300/500")
    }
    
    static func mockPhoto2() -> Photo {
        Photo(thumbnail: "https://picsum.photos/id/526/300/500", url: "https://picsum.photos/id/526/300/500")
    }
    
    static func mockPhoto3() -> Photo {
        Photo(thumbnail: "https://picsum.photos/id/527/300/500", url: "https://picsum.photos/id/527/300/500")
    }
    
    static func mockUser() -> User {
        return User(_id: "65971589d4f4d7af9f97a3bc", email: "cassandra_labadie-brown36@yahoo.com", apiKey: "aeea2aee5e942ae7b2ce2618d9bce36b7d4f4cac868bf34df9bfd7dc2279acce69c03ca34570d42cc1a668e3aa7359a7784979938fead2052d31c6a110e94c7e")
    }
    
    static func mockUser2() -> User {
        return User(_id: "65971715d4f4d7af9f97d889", email: "giovanny_dach-bins15@gmail.com", apiKey: "00bdda2d44401b66b309bec2ec3d7e4ae6b975b2824fd4f814f11023369886cb83e005e5a1fc97b783bd4110e948bd345053c364b50a84cc48245d4d0de380a8")
    }
    
    static func mockProfile() -> UserProfile {
        return UserProfile(userId: "65971589d4f4d7af9f97a3bc", screenId: "d0rk4vpj9p", firstName: "Kayla", lastName: "Koch", city: "Melodyview", state: "Washington", country: .canada, jobTitle: "Regional Group Technician", company: "Larkin LLC", field: .science, degree: "Paradigm", aboutMe: "Curo dolores cornu demulceo distinctio cunae truculenter clibanus.", userPhotos: [MockData.mockPhoto(), MockData.mockPhoto1(), MockData.mockPhoto2()], languages: [.english, .french], numberOfFollowers: 55, numberFollowing: 1)
    }
    
    static func mockProfile2() -> UserProfile {
        return UserProfile(userId: "65971715d4f4d7af9f97d889", screenId: "0a6wb8asjp", firstName: "Reva", lastName: "Cormier", city: "Ephraimchester", state: "West Virginia", country: .usa, jobTitle: "Lead Response Administrator", company: "Fritsch, Lehner and Klein", field: .social, degree: "Communications", aboutMe: "Apparatus desipio adfectus tripudio super solvo utroque amor perspiciatis earum.", userPhotos: [MockData.mockPhoto3(), MockData.mockPhoto2(), MockData.mockPhoto1()], languages: [.english], numberOfFollowers: 55, numberFollowing: 1)
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
        return Request(_id: "659bb0700c47d17cc781f078", createdDate: Date(timeIntervalSince1970: 1704568893224 / 1000), bookingUserId: MockData.mockProfile().userId, bookingUser: MockData.mockProfile(), hostUserId: MockData.mockProfile2().userId, hostUser: MockData.mockProfile2(), topicId: MockData.mockTopic()._id, topic: MockData.mockTopic(), startTime: Date(timeIntervalSince1970: 1704449058905 / 1000), endTime: Date(timeIntervalSince1970: 1704470549714 / 1000), status: .PENDING_APPROVAL)
    }
    
    static func mockRequest2() -> Request {
        return Request(_id: "659bb0700c47d17cc781f078", createdDate: Date(timeIntervalSince1970: 1704568893224 / 1000), bookingUserId: MockData.mockProfile().userId, bookingUser: MockData.mockProfile(), hostUserId: MockData.mockProfile2().userId, hostUser: MockData.mockProfile2(), topicId: MockData.mockTopic()._id, topic: MockData.mockTopic(), startTime: Date(timeIntervalSince1970: 1704449058905 / 1000), endTime: Date(timeIntervalSince1970: 1704470549714 / 1000), status: .APPROVED)
    }
    
    static func mockRequest3() -> Request {
        return Request(_id: "659bb0700c47d17cc781f078", createdDate: Date(timeIntervalSince1970: 1704568893224 / 1000), bookingUserId: MockData.mockProfile().userId, bookingUser: MockData.mockProfile(), hostUserId: MockData.mockProfile2().userId, hostUser: MockData.mockProfile2(), topicId: MockData.mockTopic()._id, topic: MockData.mockTopic(), startTime: Date(timeIntervalSince1970: 1704449058905 / 1000), endTime: Date(timeIntervalSince1970: 1704470549714 / 1000), status: .FINISHED)
    }
    
    static func mockReceipt() -> Receipt {
        return Receipt(_id: "65a6e049e7775b49c5acc1ca",
                       createdDate: DateUtil.produceDate(dateString: "2024-01-16T20:00:09.667Z", dateFormat: DateUtil.AppDateFormat.format7.rawValue)!, 
                       stripeCustomerId: "cus_PPZJLAOV7kdoSc",
                       paymentIntentId: "pi_3OZIntE0XSqZ8pU21Jkbsou7",
                       paymentIntentClientKey: "pi_3OZIntE0XSqZ8pU21Jkbsou7_secret_Cp1YWdMpbIqrip12n7KH8SOF7",
                       requestId: "65a6e049c27b1a49f5713b46",
                       status: .PAID,
                       amount: 2000,
                       currency: .CAD,
                       request: mockRequest(),
                       topic: mockTopic(),
                       bookingUser: mockProfile(),
                       statusChangeDate: DateUtil.produceDate(dateString: "2024-01-16T20:00:09.667Z", dateFormat: DateUtil.AppDateFormat.format7.rawValue)!,
                       amountPaidOut: 1600,
                       commission: 400)
    }
    
    static func mockReview() -> Review {
        return Review(_id: "65a1c929c692e4f102cb7cc0",
                      createdDate: DateUtil.produceDate(dateString: "2024-01-12T23:00:14.985+00:00", dateFormat: DateUtil.AppDateFormat.format7.rawValue)!,
                      reviewerId: mockUser()._id,
                      revieweeId: mockUser2()._id,
                      requestId: "659bb0700c47d17cc781f078",
                      rating: 5.0,
                      comment: "another good session",
                      reviewer: MockData.mockProfile())
    }
}
