//
//  CMEmailTextField.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-02.
//

import SwiftUI

struct CMEmailTextField: View {
    @Binding var text: String
    
    var body: some View {
        TextField("Email", text: $text)
            .keyboardType(.emailAddress)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
            .frame(height: 50)
            .border(.secondary)
    }
}

#Preview {
    CMEmailTextField(text: .constant("sample text"))
}
