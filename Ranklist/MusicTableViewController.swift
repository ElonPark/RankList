//
//  MusicTableViewController.swift
//  Ranklist
//
//  Created by Nebula_MAC on 2016. 1. 10..
//  Copyright © 2016년 Nebula_MAC. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
//import RealmSwift

class MusicTableViewController: UITableViewController {
    
    @IBOutlet var RTmusicTable: UITableView!
    @IBOutlet var moreBtn: UIButton!
    
    //http://m.melon.com/cds/common/mobile/openapigate_dispatcher.htm?type=album&cid=2649434&menuId=54020101
    
    // MARK: - 테이블 뷰를 구성할 리스트 데이터를 담을 배열 변수
    var list = Array<MusicVO>()
    
    /// MARK: - 현재까지 읽어온 데이터 정보
    var page = 1
    
    // MARK: - 초기 화면
	override func viewDidLoad() {
		callMusicAPI()
		
//		let realm = try? Realm()
		
	}//viewDidLoad end
    
    // MARK: - 세그웨이
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //실행된 세그웨이의 식별자가  segue_rtmdetail이라면
        if(segue.identifier == "segue_rtmdetail") {
            //sender 인자를 캐스팅하여  테이블 셀 객체로 변환한다.
            let cell = sender as! MusicCell
            
            //세그웨이를 실행한 객체 정보를 이용하여 몇 번째 행이 선택되었는지 확인한다.
            let path  = RTmusicTable.indexPath(for: cell)
            
            //API 음악 데이터 배열 중에서 선택된 행에 대한 데이터를 얻는다.
            let param = list[path!.row]
            
            //세그웨이가 향할 목적지 뷰 컨트롤러 객체를 읽어와 mvo 변수에 데이터를 연결해준다.
            (segue.destination as? DetailWebViewController)?.miz = param
            
        }
    }
    
    
    /// MARK: - 더보기 버튼
    @IBAction func more(_ sender: AnyObject) {
        //더 많은 노래 목록을 불러오기 위해
        page += 1
        
        //영화차트 API를 호출한다.
        callMusicAPI()
		
    }//more end
	
	
    /// MARK: - 음악 API
	func callMusicAPI() {
		
		//멜론API 호출을 위한 URI를 생성
		let apiURI = URL(string:"http://apis.skplanetx.com/melon/charts/realtime?count=20&page=\(self.page)&version=1&appKey=d9d377f1-756e-3bba-b050-0dc459d349e9")
		Alamofire.request(apiURI!)
			.responseJSON { reponse in
				switch reponse.result {
				case .success(let data) :
					let jsonData = JSON(data)
					let melon = jsonData["melon"].dictionaryValue
					guard let songs = melon["songs"]?.dictionaryValue else { return }
					guard let song =  songs["song"]?.arrayValue else { return }
					
					//테이블 뷰 리스트를 구성할 데이터 형식
					var mzi : MusicVO
					// Iterator 처리를 하면서 API 데이터를 MovieVO객체에 저장한다.
					
					for row in song {
						print(row)
						mzi = MusicVO()
						mzi.songName       = row["songName"].stringValue
						mzi.albumName      = row["albumName"].stringValue
						mzi.artistName     = row["artists"].stringValue
						mzi.currentRank    = row["currentRank"].intValue
						mzi.pastRank       = row["pastRank"].intValue
						mzi.isTitleSong    = row["isTitleSong"].stringValue
						
						let artists = row["artists"].dictionaryValue
						guard let artist = artists["artist"]?.arrayValue.map({ $0["artistName"].stringValue }) else { return }
						for name in artist {
							mzi.artistName = name
						}
						
						//							let albumId = row["albumId"].intValue
						//							mzi.imageUrl = "http://cdnimg.melon.co.kr/cm/album/images/100/29/181/\(albumId).jpg"
						
						let songId = row["songId"].intValue
						mzi.detail = "http://m.app.melon.com/song/lyrics.htm?songId=\(songId)"
						//예전 링크
						//"http://m.melon.com/cds/common/mobile/openapigate_dispatcher.htm?type=album&cid=\(albumId)"
						self.list.append(mzi)
					}
					//전체 데이터 카운트를 얻는다.
					let totalCount = 100
					
					//totalCount가 읽어온 데이터 크기와 같거나 클 경우 더보기 버튼을 막는다.
					if(self.list.count >= totalCount) {
						self.moreBtn.isHidden = true
					}
					
					//데이터를 다시 읽어오도록 테이블 뷰를 갱신
					self.RTmusicTable.reloadData()
				case .failure(let error) :
					print(error)
					let alert  = UIAlertController(title: "경고", message: "API 에러", preferredStyle: .alert)
					let cancelAction = UIAlertAction(title: "확인", style: .cancel) { _ in
						exit(0)
					}
					alert.addAction(cancelAction)
					self.present(alert, animated: true, completion: nil)
				}
		}
	}//API end
	
    // MARK: - 테이블 뷰 구성
	// MARK: - 테이블 뷰 행의 개수를 반환하는 메소드를 재정의한다.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
	
	// MARK: - 테이블 뷰 셀 내용 구성
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //주어진 행에 맞는 데이터 소스를 가져옴
        let row = list[indexPath.row]
		
        //NSLog("result = \(row.songName!), row index = \(indexPath.row)")
		
		
        //as! UITableViewCell => as! MovieCell로 캐스팅 타입 변경
        let cell = tableView.dequeueReusableCell(withIdentifier: "rtmCell") as! MusicCell!
		
//		let imgURL = URL(string: row.imageUrl!)
//		cell?.albumImg.af_setImage(withURL: imgURL!)
		
        //데이터 소스에 저장된 값을 각 레이블 변수에 할당
        if Bool(row.isTitleSong!)! {
            cell?.songName?.text = row.songName
        }else {
            cell?.songName.textColor = UIColor.gray
            cell?.songName?.text = row.songName
        }
        
        cell?.albumName?.text = row.albumName
        cell?.artist?.text = row.artistName
        cell?.cRank?.text = "\(row.currentRank!)"
        
        let ranNum : Int?
        
        if row.pastRank! > row.currentRank! {
            cell?.pastRank?.textColor = UIColor.red
            ranNum = row.pastRank! - row.currentRank!
            cell?.pastRank?.text = "▲\(ranNum!)"
        }else if row.pastRank! < row.currentRank! {
            cell?.pastRank?.textColor = UIColor.blue
            ranNum = row.currentRank! - row.pastRank!
            cell?.pastRank?.text = "▼\(ranNum!)"
        }else {
            cell?.pastRank?.textColor = UIColor.gray
            cell?.pastRank?.text = "-"
        }
		
        //구성된 셀을 반환함
        return cell!
    }
}//class end
