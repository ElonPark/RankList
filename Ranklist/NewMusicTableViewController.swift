//
//  NewMusicTableViewController.swift
//  Ranklist
//
//  Created by Nebula_MAC on 2016. 1. 10..
//  Copyright © 2016년 Nebula_MAC. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class NewMusicTableViewContrller : UITableViewController {
	
	@IBOutlet var newMusicTable: UITableView!
	@IBOutlet var moreBtn: UIButton!
	
	// MARK: - 테이블 뷰를 구성할 리스트 데이터를 담을 배열 변수
	var list = Array<MusicVO>()
	
	// MARK: - 현재까지 읽어온 데이터 페이지 정보
	var page = 1
	
	
	// MARK: - VC 초기화
	override func viewDidLoad() {
		self.callMusicAPI()
	}
	
	// MARK: - 세그웨이
	//=============================세그웨이=====================================
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		//실행된 세그웨이의 식별자가  segue_rtmdetail이라면
		if(segue.identifier == "segue_newdetail") {
			//sender 인자를 캐스팅하여  테이블 셀 객체로 변환한다.
			let cell = sender as! NewreleaseCell
			
			//세그웨이를 실행한 객체 정보를 이용하여 몇 번째 행이 선택되었는지 확인한다.
			let path  = self.newMusicTable.indexPath(for: cell)
			
			//API 음악 데이터 배열 중에서 선택된 행에 대한 데이터를 얻는다.
			let param = self.list[path!.row]
			
			//세그웨이가 향할 목적지 뷰 컨트롤러 객체를 읽어와 miz 변수에 데이터를 연결해준다.
			(segue.destination as? DetailWebViewController)?.miz = param
			
		}
	}
	
	
	// MARK: - 더보기 버튼
	@IBAction func more(_ sender: AnyObject) {
		//더 많은 노래 목록을 불러오기 위해
		page += 1
		
		//영화차트 API를 호출한다.
		callMusicAPI()
	}
	
	
	// MARK: - 음악 API
	func callMusicAPI() {
		let apiURI = URL(string:"http://apis.skplanetx.com/melon/newreleases/albums?count=20&page=\(self.page)&version=1&appKey=d9d377f1-756e-3bba-b050-0dc459d349e9")
		
		Alamofire.request(apiURI!)
			.responseJSON { (reponse) in
				switch reponse.result {
				case .success(let data) :
					let jsonData = JSON(data)
					let melon = jsonData["melon"].dictionaryValue
					let albums = melon["albums"]?.dictionaryValue
					let album =  albums?["album"]?.arrayValue
					
					//테이블 뷰 리스트를 구성할 데이터 형식
					var mzi : MusicVO
					// Iterator 처리를 하면서 API 데이터를 MovieVO객체에 저장한다.
					if let albumValue = album {
						for row in albumValue {
							print(row)
							mzi = MusicVO()
							
							mzi.albumName      = row["albumName"].stringValue
							mzi.artistName     = row["artists"].stringValue
							mzi.issueDate      = row["issueDate"].stringValue
							mzi.totalSongCount = row["totalSongCount"].intValue
							mzi.averageScore   = row["averageScore"].stringValue
							
							let artists = row["repArtists"].dictionaryValue
							let artist = artists["artist"]?.arrayValue.map({$0["artistName"].stringValue})
							for ro2 in artist! {
								mzi.artistName = ro2
							}
							
							let albumId = row["albumId"].intValue
							mzi.detail = "http://m.app.melon.com/album/music.htm?albumId=\(albumId)"
								//"http://m.melon.com/cds/common/mobile/openapigate_dispatcher.htm?type=album&cid=\(albumId)"
							self.list.append(mzi)
						}
					}
					//전체 데이터 카운트를 얻는다.
					let totalCount = 100
					
					//totalCount가 읽어온 데이터 크기와 같거나 클 경우 더보기 버튼을 막는다.
					if(self.list.count >= totalCount) {
						self.moreBtn.isHidden = true
					}
					
					//데이터를 다시 읽어오도록 테이블 뷰를 갱신
					self.newMusicTable.reloadData()
					
				case .failure(let error) :
					print(error)
					let alert  = UIAlertController(title: "경고", message: "API 에러", preferredStyle: .alert)
					let cancelAction = UIAlertAction(title: "확인", style: .cancel, handler: {(_) in
						exit(0)
					})
					alert.addAction(cancelAction)
					self.present(alert, animated: true, completion: nil)
				}
		}
	}//API end
	
	// MARK: - 테이블 뷰 구성
	
	// MARK: - 테이블 뷰 행의 개수를 반환하는 메소드를 재정의한다.
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.list.count
	}
	
	// MARK: -  테이블뷰의 셀 내용 정의
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		//주어진 행에 맞는 데이터 소스를 가져옴
		let row = self.list[indexPath.row]
		
		//NSLog("result = \(row.songName!), row index = \(indexPath.row)")
		
		/*여기서부터 변경 내용 시작*/
		//as! UITableViewCell => as! MovieCell로 캐스팅 타입 변경
		let cell = tableView.dequeueReusableCell(withIdentifier: "nmCell") as! NewreleaseCell!
		
		
		//데이터 소스에 저장된 값을 각 레이블 변수에 할당
		cell?.albumName?.text = row.albumName
		cell?.issueDate?.text = row.issueDate
		cell?.countScore?.text = "\(row.totalSongCount!)곡 / 평점:\(row.averageScore!)"
		cell?.artistName?.text = row.artistName
		
		//구성된 셀을 반환함
		return cell!
	}
}
