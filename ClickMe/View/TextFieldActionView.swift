//
//  AppetizerDetailView.swift
//  Appetizers
//
//  Created by Leon Chen on 2023-11-27.
//

import SwiftUI

struct TextFieldActionView: View {
    let buttonText: String
    @Binding var isShowingView: Bool
    @Binding var typingMessage: String
    var actionHandler: () -> Void
    
    @State var errorMessage: String?
    
    private let screenWidth = UIScreen.main.bounds.size.width
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField("Send a message along with the action",
                      text: $typingMessage,
                      axis: .vertical)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .textInputAutocapitalization(.sentences)
            .lineLimit(8...12)
            .keyboardType(.default)
            .padding(.horizontal, 5)
            .padding(.top, 10)
            
            if let errorMessage = errorMessage {
                CMErrorLabel(errorMessage)
            }
            
            Button(action: {
                if typingMessage.isEmpty {
                    errorMessage = "Please type a message"
                    return
                }
                errorMessage = nil
                isShowingView = false
                actionHandler()
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
                        typingMessage: .constant(""),
                        actionHandler: {
        print("action button pressed")
    })
}
