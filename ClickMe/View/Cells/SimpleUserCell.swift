//
//  SimpleUserCell.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-10.
//

import SwiftUI

struct SimpleUserCell: View {
    @State var profile: UserProfile
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            if let urlString = profile.avatarUrl {
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
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .clipped()
            } else {
                Image("male-l", bundle: nil)
                    .resizable()
                    .frame(height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .clipped()
            }
            
            VStack(alignment: .leading) {
                Text(profile.fullName)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                Text("\(profile.jobTitle ?? "")")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
            }
            
            Spacer()
        }
        .frame(height: 90)
        .padding(.all, 10)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    SimpleUserCell(profile: MockData.mockProfile())
}
