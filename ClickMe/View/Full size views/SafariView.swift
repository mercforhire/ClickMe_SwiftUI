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
    
    var body: some View {
        NavigationView {
            MyWebView(url: url)
        }
    }
}

#Preview {
    SafariView(url: URL(string: "www.yahoo.com")!, isShowWebView: .constant(true))
}
