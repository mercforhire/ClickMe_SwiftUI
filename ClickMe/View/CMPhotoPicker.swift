//
//  CMPhotoPicker.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-03.
//

import SwiftUI
import PhotosUI

struct CMPhotoPicker: View {
    @Binding var avatarItem: PhotosPickerItem?
    
    var body: some View {
        PhotosPicker("Select a photo", selection: $avatarItem, matching: .images)
    }
}

#Preview {
    CMPhotoPicker(avatarItem: .constant(nil))
}
