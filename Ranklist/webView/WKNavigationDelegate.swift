//
//  WKNavigationDelegate.swift
//  Ranklist
//
//  Created by Elon on 12/02/2019.
//  Copyright © 2019 Nebula_MAC. All rights reserved.
//

import UIKit
import WebKit

extension WebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        let urlString = navigationAction.request.url?.absoluteString ?? ""
        
        if !urlString.isEmpty && !urlString.hasPrefix("http") {
            UIApplication.shared.openURL(navigationAction.request.url!)
            decisionHandler(.cancel)
            return
        }
        
        decisionHandler(.allow)
    }
    
    //로딩 끝나면 프로그래뷰 없어짐
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.setProgress(0.0, animated: false)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        errorAlertFunc("loading error = \(error.localizedDescription)")
    }
    
    //웹뷰가 웹페이지 로드를 실패 했을때
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
        print("loading error = \(error.localizedDescription)")
    }
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        guard !webView.isLoading else { return }
        webView.reload()
    }
}
