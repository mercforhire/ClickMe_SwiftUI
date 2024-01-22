//
//  MyWebView.swift
//  Apple-Frameworks
//
//  Created by Leon Chen on 2023-11-25.
//

import SwiftUI
import WebKit

struct MyWebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let wKWebView = WKWebView()
        return wKWebView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
