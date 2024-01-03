//
//  CMErrorLabel.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-02.
//

import SwiftUI

struct CMErrorLabel: View {
    var text: String
    
    var body: some View {
        Text("* \(text)")
            .font(.footnote)
            .fontWeight(.light)
            .foregroundColor(.red)
    }
    
    init(_ text: String) {
        self.text = text
    }
}

#Preview {
    CMErrorLabel("Something wrong")
}
