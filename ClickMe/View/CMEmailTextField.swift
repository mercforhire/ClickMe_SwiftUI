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
            .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6))
            .frame(height: 50)
            .border(.secondary)
    }
}

#Preview {
    CMEmailTextField(text: .constant("sample text"))
}
