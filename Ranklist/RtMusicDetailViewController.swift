//
//  RtMusicDetailViewController.swift
//  Ranklist
//
//  Created by Nebula_MAC on 2016. 1. 10..
//  Copyright © 2016년 Nebula_MAC. All rights reserved.
//

import UIKit

class RtMusicDetailViewController: UIViewController {
    
    @IBOutlet var navibar: UINavigationItem!
    @IBOutlet var wv: UIWebView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    //목록에서 음악 데이터를 받을 변수
    var miz : MusicVO? = nil
    
    //목록에서 영화 데이터를 받을 변수
    var mvo : MovieVO? = nil
    override func viewDidLoad() {
        
        if miz != nil && mvo == nil {
        self.navibar.title = self.miz?.songName
        
        //예외 처리
        if let url = self.miz?.detail {
            if let urlObj = NSURL(string: url){
                let req = NSURLRequest(URL: urlObj)
                self.wv.loadRequest(req)
                
            }else { //URL 형식이 잘못 되었을 경우에 대한 예외처리
                
                //경고창 형식으로 오류 메시지를 표시해준다.
                let alert = UIAlertController(title: "오류", message: "잘못된 URL입니다", preferredStyle: .Alert)
                
                let cancelAction = UIAlertAction(title: "확인", style: .Cancel) { (_) in //익명함수 사용
                    //이전 페이지로 돌려보낸다.
                    self.navigationController?.popToRootViewControllerAnimated(true)
                }//클로저 end
                alert.addAction(cancelAction)
                self.presentViewController(alert, animated: false, completion: nil)
            }//if end
            
        } else { //URL 값이 전달되지 않았을 경우에 대한 예외처리
            
            //경고창 형식으로 오류 메시지를 표시해준다.
            let alert = UIAlertController(title: "오류", message: "필수 파라미터가 누락되었습니다.", preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "확인", style: .Cancel) { (_) in //클로저
                //이전 페이지로 돌려보낸다.
                self.navigationController?.popToRootViewControllerAnimated(true)
            }// 클로저 end
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: false, completion: nil)
        }//if end
            
            
        }else if mvo != nil && miz == nil  {
            self.navibar.title = self.mvo?.movieNm
            
            //예외 처리
            if let url = self.mvo?.detail {
                if let urlObj = NSURL(string: url){
                    let req = NSURLRequest(URL: urlObj)
                    self.wv.loadRequest(req)
                    
                }else { //URL 형식이 잘못 되었을 경우에 대한 예외처리
                    
                    //경고창 형식으로 오류 메시지를 표시해준다.
                    let alert = UIAlertController(title: "오류", message: "잘못된 URL입니다", preferredStyle: .Alert)
                    
                    let cancelAction = UIAlertAction(title: "확인", style: .Cancel) { (_) in //익명함수 사용
                        //이전 페이지로 돌려보낸다.
                        self.navigationController?.popToRootViewControllerAnimated(true)
                    }//클로저 end
                    alert.addAction(cancelAction)
                    self.presentViewController(alert, animated: false, completion: nil)
                }//if end
                
            } else { //URL 값이 전달되지 않았을 경우에 대한 예외처리
                
                //경고창 형식으로 오류 메시지를 표시해준다.
                let alert = UIAlertController(title: "오류", message: "필수 파라미터가 누락되었습니다.", preferredStyle: .Alert)
                
                let cancelAction = UIAlertAction(title: "확인", style: .Cancel) { (_) in //클로저
                    //이전 페이지로 돌려보낸다.
                    self.navigationController?.popToRootViewControllerAnimated(true)
                }// 클로저 end
                alert.addAction(cancelAction)
                self.presentViewController(alert, animated: false, completion: nil)
            }//else end
        } //if mvo end
    }//DidLoad end
    
        
        
    //웹 뷰가  웹페이지를 로드하기 시작할 때
    func webViewDidStartLoad(webView: UIWebView) {
        self.spinner.startAnimating() //인디케이터 뷰의 애니메이션을 실행
    }//webViewDidStartLoad end
    
    //웹 뷰가 웹페이지 로드를 완료했을 때
    func webViewDidFinishLoad(webView: UIWebView) {
        self.spinner.stopAnimating() //인디케이터 뷰의 애니메이션을 중지
    }//webViewDidFinishLoad end
    
    //웹 뷰가 웹페이지 로드를 실패 했을때
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        self.spinner.stopAnimating()
        
        //경고창 형식으로 오류 메시지를 표시해준다.
        let alert = UIAlertController(title: "오류", message: "상세페이지를 읽어오지 못했습니다.", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "확인", style: .Cancel) { (_) in //클로저
            //이전 페이지로 돌려보낸다.
            self.navigationController?.popToRootViewControllerAnimated(true)
        }// 클로저 end
        alert.addAction(cancelAction)
        self.presentViewController(alert, animated: false, completion: nil)
    }//webviewDidFailLoadWithError //end
    
}