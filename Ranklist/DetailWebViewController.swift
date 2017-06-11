//
//  DetailWebViewController.swift
//  Ranklist
//
//  Created by Nebula_MAC on 2016. 1. 10..
//  Copyright © 2016년 Nebula_MAC. All rights reserved.
//

import UIKit
import WebKit


class DetailWebViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
	
	@IBOutlet var navibar: UINavigationItem!
	
	@IBOutlet weak var wkUIView: UIView!
	@IBOutlet weak var progressView: UIProgressView!
	
	var wkWV : WKWebView = WKWebView()
	
	var canReload : Bool = false
	
	//목록에서 음악 데이터를 받을 변수
	var miz : MusicVO? = nil
	
	//목록에서 영화 데이터를 받을 변수
	var mvo : MovieVO? = nil
	
	deinit {
		self.wkWV.removeObserver(self, forKeyPath: "estimatedProgress")
	}
	
	
	//뷰가 나타날때 회전상태를 확인하여 크기를 가져옴
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
//		self.checkOrientate()
	}
	
	//뷰가 나타났으면 wk웹뷰의 프레임 크기를 설정한다.
	override func viewDidAppear(_ animated: Bool) {
		//뷰 위아래에 네비게이션바와 탭바 메뉴 때문에 값을 이렇게 설정한다.
//		self.checkOrientate()
		wkWV.frame = wkUIView.bounds
	}
	
	override func viewDidLoad() {
		automaticallyAdjustsScrollViewInsets = false

		wkWV.uiDelegate = self
		wkWV.navigationDelegate = self
		//UIView에 wk웹뷰, 프로그래스뷰 부착
		self.wkUIView.insertSubview(self.wkWV, belowSubview: self.progressView)
		
		//프로그래스뷰를 위한 옵저버
		self.wkWV.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
		wkWV.frame = wkUIView.frame
		self.wkWV.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		self.urlLoadFunc()
	}//DidLoad end

	func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
		if canReload {
			canReload = false
			wkWV.reload()
		}
	}
	
	func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
		if !navigationAction.request.url!.absoluteString.hasPrefix("http") {
			UIApplication.shared.openURL(navigationAction.request.url!)
		}
		decisionHandler(WKNavigationActionPolicy.allow)
	}
	
	//로딩 끝나면 프로그래뷰 없어짐
	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		canReload = true
		progressView.setProgress(0.0, animated: false)
	}
	
	//프로그래뷰 애니메이션
	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		if (keyPath! == "estimatedProgress") {
			progressView.isHidden = self.wkWV.estimatedProgress == 1
			progressView.setProgress(Float((wkWV.estimatedProgress)), animated: true)
		}
	}
	
	func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
		errorAlertFunc("loading error = \(error.localizedDescription)")
	}
	
	//웹 뷰가 웹페이지 로드를 실패 했을때
	func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
		//경고창 형식으로 오류 메시지를 표시해준다.
//		errorAlertFunc("loading error = \(error.localizedDescription)")
		print("loading error = \(error.localizedDescription)")
	}
	
	func urlLoadFunc() {
		if miz != nil && mvo == nil {
			self.navibar.title = self.miz?.songName
			//예외 처리
			if let url = self.miz?.detail {
				if let urlObj = URL(string: url){
					let req = URLRequest(url: urlObj)
					self.wkWV.load(req)
				}else { //URL 형식이 잘못 되었을 경우에 대한 예외처리
					//경고창 형식으로 오류 메시지를 표시해준다.
					errorAlertFunc("잘못된 URL입니다")
				}//if end
			} else { //URL 값이 전달되지 않았을 경우에 대한 예외처리
				//경고창 형식으로 오류 메시지를 표시해준다.
				errorAlertFunc("필수 파라미터가 누락되었습니다.")
				}//if end
			}else if mvo != nil && miz == nil  {
			self.navibar.title = self.mvo?.movieNm
			
			//예외 처리
			if let url = self.mvo?.detail {
				if let urlObj = URL(string: url){
					let req = URLRequest(url: urlObj)
					self.wkWV.load(req)
				}else { //URL 형식이 잘못 되었을 경우에 대한 예외처리
					//경고창 형식으로 오류 메시지를 표시해준다.
					errorAlertFunc("잘못된 URL입니다")
				}//if end
			} else { //URL 값이 전달되지 않았을 경우에 대한 예외처리
				//경고창 형식으로 오류 메시지를 표시해준다.
				errorAlertFunc("필수 파라미터가 누락되었습니다.")
			}//else end
		} //if mvo end
	}//urlLoadFunc end
	
	func errorAlertFunc(_ msg : String){
		//경고창 형식으로 오류 메시지를 표시해준다.
		let alert = UIAlertController(title: "오류", message: msg, preferredStyle: .alert)
		
		let cancelAction = UIAlertAction(title: "확인", style: .cancel) { (_) in //익명함수 사용
			//이전 페이지로 돌려보낸다.
//self.navigationController?.popToRootViewController(animated: true)
			self.dismiss(animated: true, completion: nil)
		}//클로저 end
		alert.addAction(cancelAction)
		self.present(alert, animated: false, completion: nil)
	}
	
	func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: (@escaping () -> Void)) {
		//print("webView:\(webView) runJavaScriptAlertPanelWithMessage:\(message) initiatedByFrame:\(frame) completionHandler:\(completionHandler)")
		
		let alertController = UIAlertController(title: frame.request.url?.host, message: message, preferredStyle: .alert)
		alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
			completionHandler()
		}))
		self.present(alertController, animated: true, completion: nil)
	}
	
	func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: (@escaping (Bool) -> Void)) {
		//print("webView:\(webView) runJavaScriptConfirmPanelWithMessage:\(message) initiatedByFrame:\(frame) completionHandler:\(completionHandler)")
		
		let alertController = UIAlertController(title: frame.request.url?.host, message: message, preferredStyle: .alert)
		alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
			completionHandler(false)
		}))
		alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
			completionHandler(true)
		}))
		self.present(alertController, animated: true, completion: nil)
	}
	
	func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
		//print("webView:\(webView) runJavaScriptTextInputPanelWithPrompt:\(prompt) defaultText:\(defaultText) initiatedByFrame:\(frame) completionHandler:\(completionHandler)")
		
		let alertController = UIAlertController(title: frame.request.url?.host, message: prompt, preferredStyle: .alert)
		weak var alertTextField: UITextField!
		alertController.addTextField { textField in
			textField.text = defaultText
			alertTextField = textField
		}
		alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
			completionHandler(nil)
		}))
		alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
			completionHandler(alertTextField.text)
		}))
		self.present(alertController, animated: true, completion: nil)
	}
	
}
