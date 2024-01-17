//
//  ProfilePhotosGridView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-03.
//

import SwiftUI

struct ProfilePhotosGridView: View {
    @Binding var photos: [Photo]
    var width: CGFloat
    var maxPhotos: Int
    let gridMatrix: [GridItem]
    var handleDeletePhoto: (Int) -> Void
    var handlePhotoPicker: () -> Void
    
    var body: some View {
        LazyVGrid(columns: gridMatrix) {
            ForEach(0..<maxPhotos) { index in
                if index < photos.count {
                    CMPhotoCellView(photo: photos[index], width: width, height: width)
                        .onTapGesture {
                            handleDeletePhoto(index)
                        }
                        .id(UUID())
                } else {
                    CMPhotoCellView(width: width, height: width)
                        .onTapGesture {
                            handlePhotoPicker()
                        }
                        .id(UUID())
                }
            }
        }
    }
}

#Preview {
    let url = "https://media.licdn.com/dms/image/C5603AQFAiZ5E98oI1w/profile-displayphoto-shrink_200_200/0/1564032471373?e=1709769600&v=beta&t=xuD6QC1lVyhH5CVpT6GIdK_CZnm317WMp5xTnD-Du40"
    let photo = Photo(thumbnail: url, url: url)
    return ProfilePhotosGridView(photos: .constant([photo]),
                                 width: 150,
                                 maxPhotos: 10,
                                 gridMatrix: [GridItem(.flexible()), GridItem(.flexible())],
                                 handleDeletePhoto: { index in
        print("handleDeletePhoto:", index)
    }, handlePhotoPicker: {
        print("handlePhotoPicker:")
    })
}
