//
//  ExploreCell.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-04.
//

import SwiftUI

struct ExploreCell: View {
    var profile: UserProfile
    var imageWidth: CGFloat
    var imageHeight: CGFloat
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                if let urlString = profile.userPhotos.first?.url {
                    AsyncImage(url: URL(string: urlString)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Image("male-l", bundle: nil)
                            .resizable()
                            .scaledToFill()
                            .opacity(0.5)
                    }
                    .frame(width: imageWidth, height: imageHeight)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .clipped()
                } else {
                    Image("male-l", bundle: nil)
                        .resizable()
                        .frame(width: imageWidth, height: imageHeight)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .clipped()
                }
                VStack(alignment: .leading) {
                    Text("\(profile.firstName) \(profile.lastName)")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    HStack {
                        Image(profile.field.imageName(), bundle: nil)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 30, height: 30)
                        Text("\(profile.jobTitle))")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                        Spacer()
                        HStack {
                            Image(systemName: "heart.fill")
                                .resizable()
                                .foregroundStyle(.pink)
                                .frame(width: 30, height: 25)
                                .opacity(0.8)
                            Text("\(profile.numberOfFollowers ?? 0)")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.primary)
                        }
                        .padding(10)
                        .background(.background)
                        .clipShape(Capsule())
                    }
                }
            }
            .padding(.all, 20)
        }
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.all, 10)
    }
}

#Preview {
    return ExploreCell(profile: UserProfile.mockProfile(), imageWidth: 300, imageHeight: 200)
}
