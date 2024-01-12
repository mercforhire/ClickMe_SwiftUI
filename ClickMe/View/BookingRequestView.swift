//
//  BookingRequestView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-08.
//

import SwiftUI

struct BookingRequestView: View {
    var request: Request
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top, spacing: 20) {
                if let urlString = request.hostUser?.avatarThumbnailUrl {
                    AsyncImage(url: URL(string: urlString)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        Image("male-l", bundle: nil)
                            .resizable()
                            .scaledToFill()
                            .opacity(0.5)
                    }
                    .frame(width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .clipped()
                    VStack(alignment: .leading) {
                        Text("\(request.hostUser?.firstName ?? "") \(request.hostUser?.lastName ?? "")")
                            .font(.body)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        Text(request.hostUser?.jobTitle ?? "")
                            .font(.subheadline)
                            .foregroundColor(.primary)
                    }
                }
                Spacer()
                Image(request.topic?.mood.imageName() ?? "field_other", bundle: nil)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
            }
            
            Divider()
                .frame(height: 1)
                .overlay(.primary)
            
            Text(request.timeAndDuration)
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
            
            Text(request.topic?.title ?? "")
                .font(.title3)
                .fontWeight(.medium)
                .foregroundColor(.primary)
                .padding(.vertical, 5)
            
            Spacer()
            
            Text(request.status.text())
                .font(.body)
                .fontWeight(.bold)
                .foregroundColor(request.status == .DECLINED ? .red : .accent)
                .frame(maxWidth: .infinity, alignment: .trailing)

        }
        .padding(.all, 20)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    BookingRequestView(request: MockData.mockRequest())
}
