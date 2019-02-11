//
//  WKUIDelegate.swift
//  Ranklist
//
//  Created by Elon on 12/02/2019.
//  Copyright © 2019 Nebula_MAC. All rights reserved.
//

import UIKit
import WebKit

extension WebViewController {
    ///자바스크립트 Alert
    func alertPanel(with message: String, title: String?, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인",
                                     style: .default) { _ in
                                        completionHandler()
        }
        
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
    
    ///자바스크립트 확인 Alert
    func alertConfirmPanel(with message: String, title: String?, completionHandler: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인",
                                     style: .default) { _ in
                                        completionHandler(true)
        }
        
        let cancelAction = UIAlertAction(title: "취소",
                                         style: .cancel) { _ in
                                            completionHandler(false)
        }
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    ///자바스크립트 입력 Alert
    func alertTextInputPanel(withPrompt prompt: String, defaultText: String?, completionHandler: @escaping (String?) -> Void) {
        
        let alert = UIAlertController(title: prompt,
                                      message: prompt,
                                      preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.text = defaultText
        }
        
        let okAction = UIAlertAction(title: "확인",
                                     style: .default) { _ in
                                        completionHandler(alert.textFields?.first?.text)
        }
        
        let cancelAction = UIAlertAction(title: "취소",
                                         style: .cancel) { _ in
                                            completionHandler(nil)
        }
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
}

extension WebViewController: WKUIDelegate {
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        //새창처리 안하고 현재 웹뷰에 로드함
        webView.load(navigationAction.request)
        
        return nil
    }
    
    func webViewDidClose(_ webView: WKWebView) {
        webView.goBack()
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
        alertPanel(with: message,
                   title: webView.url?.host,
                   completionHandler: completionHandler)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        
        alertConfirmPanel(with: message,
                          title: webView.url?.host,
                          completionHandler: completionHandler)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        
        alertTextInputPanel(withPrompt: prompt,
                            defaultText: defaultText,
                            completionHandler: completionHandler)
    }
}
