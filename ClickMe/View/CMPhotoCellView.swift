//
//  CMPhotoCellView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-03.
//

import SwiftUI

struct CMPhotoCellView: View {
    var photo: Photo?
    var width: CGFloat
    
    var body: some View {
        ZStack {
            if let photo = photo {
                AsyncImage(url: URL(string: photo.thumbnail)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.accentColor
                }
                .frame(width: width, height: width)
                .clipped()
            } else {
                Image("male-l", bundle: nil)
                    .resizable()
                    .scaledToFill()
                    .frame(width: width, height: width)
                    .clipped()
            }
            Image("frame", bundle: nil)
                .resizable()
                .frame(width: width, height: width)
                .foregroundStyle(.background)
            Image("border", bundle: nil)
                .resizable()
                .frame(width: width, height: width)
                .foregroundStyle(.accent)
        }
        .frame(width: width, height: width)
        .overlay(alignment: .bottomTrailing) {
            if let _ = photo {
                CMMinusButton()
                    .padding([.bottom, .trailing], width / 10)
            } else {
                CMPlusButton()
                    .padding([.bottom, .trailing], width / 10)
            }
        }
    }
}

#Preview {
    let url = "https://media.licdn.com/dms/image/C5603AQFAiZ5E98oI1w/profile-displayphoto-shrink_200_200/0/1564032471373?e=1709769600&v=beta&t=xuD6QC1lVyhH5CVpT6GIdK_CZnm317WMp5xTnD-Du40"
    let photo = Photo(thumbnail: url, url: url)
    return CMPhotoCellView(photo: photo, width: 200)
}
