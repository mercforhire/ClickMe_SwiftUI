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
    var urlChangeHandler: ((String) -> Void)? = nil
    
    func makeUIView(context: Context) -> WKWebView {
        let wKWebView = WKWebView()
        wKWebView.navigationDelegate = context.coordinator
        return wKWebView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    func makeCoordinator() -> WebViewCoordinator {
        WebViewCoordinator(self)
    }
}

class WebViewCoordinator: NSObject, WKNavigationDelegate {
    var parent: MyWebView
    
    init(_ parent: MyWebView) {
        self.parent = parent
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let urlStr = navigationAction.request.url?.absoluteString {
            parent.urlChangeHandler?(urlStr)
        }
        decisionHandler(.allow)
    }
    
}

#Preview {
    MyWebView(url: URL(string: "https://ca.yahoo.com/")!) { url in
        print("url changed to: ", url)
    }
}
