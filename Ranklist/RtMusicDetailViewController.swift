//
//  RtMusicDetailViewController.swift
//  Ranklist
//
//  Created by Nebula_MAC on 2016. 1. 10..
//  Copyright © 2016년 Nebula_MAC. All rights reserved.
//

import UIKit
import WebKit


class RtMusicDetailViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
	
	@IBOutlet var navibar: UINavigationItem!
	
	@IBOutlet weak var wkUIView: UIView!
	@IBOutlet weak var progressView: UIProgressView!
	
	var wkWV : WKWebView = WKWebView()

	//목록에서 음악 데이터를 받을 변수
	var miz : MusicVO? = nil
	
	//목록에서 영화 데이터를 받을 변수
	var mvo : MovieVO? = nil
	
	var portrait = false //화면이 회전상태인지 확인하기 위함
	
	deinit {
		self.wkWV.removeObserver(self, forKeyPath: "estimatedProgress")
	}
	
	
	//뷰가 나타날때 회전상태를 확인하여 크기를 가져옴
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		self.checkOrientate()
	}
	
	//뷰가 나타났으면 wk웹뷰의 프레임 크기를 설정한다.
	override func viewDidAppear(animated: Bool) {
		self.wkWV.frame = CGRectMake(0, 0, self.wkUIView.frame.width, self.wkUIView.frame.height)
	}
	
	override func viewDidLoad() {
		wkWV.UIDelegate = self
		wkWV.navigationDelegate = self
		//UIView에 wk웹뷰, 프로그래스뷰 부착
		self.wkUIView.insertSubview(wkWV, belowSubview: self.progressView)
		
		//프로그래스뷰를 위한 옵저버
		self.wkWV.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
		self.urlLoadFunc()
	}//DidLoad end
	
	
	//회전할때 UIView 크기를 가져와서 WK웹뷰의 크기로 설정
	private func checkOrientate() {
		let ori = UIApplication.sharedApplication().statusBarOrientation
		
		if ori == UIInterfaceOrientation.Portrait {
			self.wkWV.frame = CGRectMake(0, 0, wkWV.frame.width, wkWV.frame.height)
			portrait = false
		} else {
			if portrait {
				self.wkWV.frame = CGRectMake(0, 0, self.wkWV.frame.width, self.wkWV.frame.height)
				portrait = true
			}else { //화면 눕혀져있지 않았으면 상단바 높이 추가
				self.wkWV.frame = CGRectMake(0, 0, self.wkWV.frame.width, self.wkWV.frame.height+20)
				portrait = true
			}
			
		}
	}
	
	override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
		coordinator.animateAlongsideTransition({ (UIViewControllerTransitionCoordinatorContext) -> Void in
			self.checkOrientate()
			}, completion: { (UIViewControllerTransitionCoordinatorContext) -> Void in })
	}
	
	//로딩 끝나면 프로그래뷰 없어짐
	func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
		progressView.setProgress(0.0, animated: false)
	}
	
	//프로그래뷰 애니메이션
	override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<()>) {
		if (keyPath! == "estimatedProgress") {
			progressView.hidden = self.wkWV.estimatedProgress == 1
			progressView.setProgress(Float(wkWV.estimatedProgress), animated: true)
		}
	}
	
	
	//웹 뷰가 웹페이지 로드를 실패 했을때
	func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
		//경고창 형식으로 오류 메시지를 표시해준다.
		errorAlertFunc("loading error = \(error)")
	}
	
	func urlLoadFunc(){
		if miz != nil && mvo == nil {
			self.navibar.title = self.miz?.songName
			
			//예외 처리
			if let url = self.miz?.detail {
				if let urlObj = NSURL(string: url){
					let req = NSURLRequest(URL: urlObj)
					self.wkWV.loadRequest(req)
					
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
				if let urlObj = NSURL(string: url){
					let req = NSURLRequest(URL: urlObj)
					self.wkWV.loadRequest(req)
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
	
	func errorAlertFunc(msg : String){
		//경고창 형식으로 오류 메시지를 표시해준다.
		let alert = UIAlertController(title: "오류", message: msg, preferredStyle: .Alert)
		
		let cancelAction = UIAlertAction(title: "확인", style: .Cancel) { (_) in //익명함수 사용
			//이전 페이지로 돌려보낸다.
			self.navigationController?.popToRootViewControllerAnimated(true)
		}//클로저 end
		alert.addAction(cancelAction)
		self.presentViewController(alert, animated: false, completion: nil)
	}
	
	func webView(webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: (() -> Void)) {
		//print("webView:\(webView) runJavaScriptAlertPanelWithMessage:\(message) initiatedByFrame:\(frame) completionHandler:\(completionHandler)")
		
		let alertController = UIAlertController(title: frame.request.URL?.host, message: message, preferredStyle: .Alert)
		alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
			completionHandler()
		}))
		self.presentViewController(alertController, animated: true, completion: nil)
	}
	
	func webView(webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: ((Bool) -> Void)) {
		//print("webView:\(webView) runJavaScriptConfirmPanelWithMessage:\(message) initiatedByFrame:\(frame) completionHandler:\(completionHandler)")
		
		let alertController = UIAlertController(title: frame.request.URL?.host, message: message, preferredStyle: .Alert)
		alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { action in
			completionHandler(false)
		}))
		alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
			completionHandler(true)
		}))
		self.presentViewController(alertController, animated: true, completion: nil)
	}
	
	func webView(webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: (String?) -> Void) {
		//print("webView:\(webView) runJavaScriptTextInputPanelWithPrompt:\(prompt) defaultText:\(defaultText) initiatedByFrame:\(frame) completionHandler:\(completionHandler)")
		
		let alertController = UIAlertController(title: frame.request.URL?.host, message: prompt, preferredStyle: .Alert)
		weak var alertTextField: UITextField!
		alertController.addTextFieldWithConfigurationHandler { textField in
			textField.text = defaultText
			alertTextField = textField
		}
		alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { action in
			completionHandler(nil)
		}))
		alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
			completionHandler(alertTextField.text)
		}))
		self.presentViewController(alertController, animated: true, completion: nil)
	}
	
}