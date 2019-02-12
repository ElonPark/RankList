//
//  WebViewController.swift
//  Ranklist
//
//  Created by Nebula_MAC on 2016. 1. 10..
//  Copyright © 2016년 Nebula_MAC. All rights reserved.
//

import UIKit
import WebKit

extension WebViewController {
    
    func errorAlertFunc(_ msg : String){
        let alert = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "확인", style: .cancel) { [weak self] (_) in
            self?.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(cancelAction)
        present(alert, animated: false, completion: nil)
    }
    
    func load(to urlString: String) {
        guard !urlString.isEmpty else {
            errorAlertFunc("필수 파라미터가 누락되었습니다.")
            return
        }
        guard let url = URL(string: urlString) else {
            errorAlertFunc("잘못된 URL입니다")
            return
        }
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    func loadRequest(by songData: Song?) {
        guard let song = songData else { return }
        navibar.title = song.songName
        
        load(to: song.detail)
    }
    
    func loadRequest(by albumData: Album?) {
        guard let album = albumData else { return }
        navibar.title = album.albumName
        
        load(to: album.detail)
    }
    
    func loadRequest(by movieData: BoxOffice?) {
        guard let movie = movieData else { return }
        navibar.title = movie.movieNm
        
        load(to: movie.detail)
    }
    
    func loadRequest() {
        loadRequest(by: music)
        loadRequest(by: album)
        loadRequest(by: movie)
    }
    
    ///프로그레스 업데이트
    func updateProgress(to progressBar: UIProgressView, by value: Double) {
        let progress = Float(value)
        progressBar.isHidden = progress == 1
        
        guard progressBar.progress < progress else { return }
        progressBar.setProgress(progress, animated: true)
    }
    
    ///웹뷰 프로그레스 옵저버
    func setProgressObserver() {
        progressObserveToken = webView.observe(\.estimatedProgress, options: .new) { [weak self] (_, estimatedProgress) in
            guard let newValue = estimatedProgress.newValue else { return }
            guard let progressBar = self?.progressView else { return }
            
            self?.updateProgress(to: progressBar, by: newValue)
        }
    }
    
}

class WebViewController: UIViewController {
    
    @IBOutlet var navibar: UINavigationItem!
    
    @IBOutlet weak var wkUIView: UIView!
    @IBOutlet weak var progressView: UIProgressView!
    
    lazy var webView = WKWebView()
    
    ///프로그레스 옵저버 토큰
    var progressObserveToken: NSKeyValueObservation? = nil
    
    //목록에서 음악 데이터를 받을 변수
    var music: Song? = nil
    var album: Album? = nil
    
    //목록에서 영화 데이터를 받을 변수
    var movie: BoxOffice? = nil
    
    override func viewDidLoad() {
        automaticallyAdjustsScrollViewInsets = false
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        wkUIView.insertSubview(webView, belowSubview: progressView)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        setProgressObserver()
        
        loadRequest()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = wkUIView.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}
