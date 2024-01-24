//
//  AppetizerDetailView.swift
//  Appetizers
//
//  Created by Leon Chen on 2023-11-27.
//

import SwiftUI

struct TextFieldActionView: View {
    var buttonText: String
    var placeholder: String = "Send a message along with the action"
    @Binding var isShowingView: Bool
    @State var initialMessage: String = ""
    var allowEmptyMessage: Bool = false
    var actionHandler: ((String) -> Void)?
    
    @State private var errorMessage: String?
    private let screenWidth = UIScreen.main.bounds.size.width
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField(placeholder,
                      text: $initialMessage,
                      axis: .vertical)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .textInputAutocapitalization(.sentences)
            .lineLimit(8...12)
            .keyboardType(.default)
            .padding(.horizontal, 5)
            .padding(.top, 10)
            
            if let errorMessage = errorMessage {
                CMErrorLabel(errorMessage)
                    .padding(.horizontal, 5)
            }
            
            Button(action: {
                if !allowEmptyMessage, initialMessage.isEmpty {
                    errorMessage = "Please type a message"
                    return
                }
                errorMessage = nil
                isShowingView = false
                actionHandler?(initialMessage)
            }, label: {
                Text(buttonText)
            })
            .padding(.top, 10)
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/ ,alignment: .center)
        }
        .padding(.top, 25)
        .padding(.bottom, 20)
        .padding(.horizontal, 20)
        .frame(width: screenWidth * 0.8)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 40)
        .overlay(alignment: .topTrailing) {
            Button(action: {
                isShowingView = false
            }, label: {
                CMXButton()
            })
            .padding([.top, .trailing], 5)
        }
    }
}

#Preview {
    TextFieldActionView(buttonText: "Accept",
                        isShowingView: .constant(true),
                        actionHandler: { message in
        print("message typed: \(message)")
    })
}
