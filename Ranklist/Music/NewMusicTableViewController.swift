//
//  NewMusicTableViewController.swift
//  Ranklist
//
//  Created by Nebula_MAC on 2016. 1. 10..
//  Copyright © 2016년 Nebula_MAC. All rights reserved.
//

import UIKit

extension NewMusicTableViewContrller {
    func errorAlert(_ error: Error?) {
        guard let _error = error else { return }
        let errorString = _error.localizedDescription
        
        let alert  = UIAlertController(title: "Error",
                                       message: errorString,
                                       preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "확인", style: .cancel)
        
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - 음악 API
    func callMusicAPI(with page: Int) {
        MelonAPI.request(to: .realtimeChart, with: page) { [weak self] (apiData, error) in
            defer {
                self?.errorAlert(error)
            }
            
            guard let `self` = self else { return }
            guard let musicVO = apiData else { return }
            
            self.list.append(contentsOf: musicVO.albums)
            self.moreBtn.isHidden = self.list.count >= self.totalCount
            self.newAlbumsTable.reloadData()
        }
    }
}

// MARK: - 테이블 뷰 구성
extension NewMusicTableViewContrller {
    
    // MARK: - 테이블 뷰 행의 개수를 반환하는 메소드를 재정의한다.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    // MARK: -  테이블뷰의 셀 내용 정의
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "nmCell") as! NewreleaseCell
        let data = list[indexPath.row]
        
        cell.setData(with: data)
        
        return cell
    }
}

class NewMusicTableViewContrller : UITableViewController {
	
	@IBOutlet var newAlbumsTable: UITableView!
	@IBOutlet var moreBtn: UIButton!
	
    let totalCount = 100
    
	/// 테이블 뷰를 구성할 리스트 데이터를 담을 배열 변수
	var list = [Album]()
	
	///현재까지 읽어온 데이터 페이지 정보
	var page = 1
	
    // MARK: - 더보기 버튼
    @IBAction func more(_ sender: AnyObject) {
        //더 많은 노래 목록을 불러오기 위해
        page += 1
        
        //영화차트 API를 호출한다.
        callMusicAPI(with: page)
    }
    
	// MARK: - VC 초기화
	override func viewDidLoad() {
		callMusicAPI(with: page)
	}
	
	// MARK: - 세그
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //실행된 세그웨이의 식별자가  segue_rtmdetail이라면
        guard segue.identifier == "segue_newdetail" else { return }
        //sender 인자를 캐스팅하여  테이블 셀 객체로 변환한다.
        guard let cell = sender as? NewreleaseCell else { return }
        
        //세그웨이를 실행한 객체 정보를 이용하여 몇 번째 행이 선택되었는지 확인한다.
        guard let path = newAlbumsTable.indexPath(for: cell) else { return }
        
        //API 음악 데이터 배열 중에서 선택된 행에 대한 데이터를 얻는다.
        let param = list[path.row]
        
        //세그웨이가 향할 목적지 뷰 컨트롤러 객체를 읽어와 music 변수에 데이터를 연결해준다.
        let webView = segue.destination as? WebViewController
        webView?.album = param
    }
}
