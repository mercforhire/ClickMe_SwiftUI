//
//  SafariView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-21.
//

import SwiftUI

struct SafariView: View {
    var url: URL
    @Binding var isShowWebView: Bool
    var urlChangeHandler: ((String) -> Void)? = nil
    
    var body: some View {
        NavigationView {
            MyWebView(url: url, urlChangeHandler: urlChangeHandler)
                .toolbar() {
                    ToolbarItemGroup(placement: .topBarLeading) {
                        Button("Close") {
                            isShowWebView = false
                        }
                    }
                }
        }
    }
}

#Preview {
    SafariView(url: URL(string: "https://ca.yahoo.com/")!, 
               isShowWebView: .constant(true)) { url in
        print("SafariView url changed to: ", url)
    }
}
