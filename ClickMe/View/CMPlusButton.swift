//
//  CMPlusButton.swift
//  Appetizers
//
//  Created by Leon Chen on 2023-11-27.
//

import SwiftUI

struct CMPlusButton: View {
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 40, height: 40)
                .foregroundColor(.black)
            Image(systemName: "plus")
                .imageScale(.medium)
                .foregroundColor(.white)
        }
    }
}

#Preview {
    CMPlusButton()
}
