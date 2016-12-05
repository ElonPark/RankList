//
//  MovieDayTableViewController.swift
//  Ranklist
//
//  Created by Nebula_MAC on 2016. 1. 11..
//  Copyright © 2016년 Nebula_MAC. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class MovieDayTableViewController: UITableViewController {
	
	@IBOutlet var movieDayTable: UITableView!
	
	@IBOutlet var rankday: UILabel!
	
	
	
	//테이블 뷰를 구성할 리스트 데이터를 담을 배열 변수
	var list = Array<MovieVO>()
	
	
	override func viewDidLoad() {
		callMovieAPI()
	}//viewDidLoad end
	
	
	//=============================세그웨이=====================================
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		//실행된 세그웨이의 식별자가  segue_rtmdetail이라면
		if(segue.identifier == "segue_daydetail") {
			//sender 인자를 캐스팅하여  테이블 셀 객체로 변환한다.
			let cell = sender as! MdayCell
			
			//세그웨이를 실행한 객체 정보를 이용하여 몇 번째 행이 선택되었는지 확인한다.
			let path  = self.movieDayTable.indexPath(for: cell)
			
			//API 음악 데이터 배열 중에서 선택된 행에 대한 데이터를 얻는다.
			let param = self.list[path!.row]
			
			//세그웨이가 향할 목적지 뷰 컨트롤러 객체를 읽어와 mvo 변수에 데이터를 연결해준다.
			(segue.destination as? RtMusicDetailViewController)?.mvo = param
			
		}
	}
	
	
	//영화 API
	func callMovieAPI() {
		//어제 날짜 출력, NS캘린더에서 오늘 날짜를 받아와
		let calendar = Calendar.current
		
		//어제 날짜로 변경한다.
		let yesterday = (calendar as NSCalendar).date(byAdding: .day, value: -1, to: Date(), options: [])
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyyMMdd"
		
		let targetDt = dateFormatter.string(from: yesterday!)
		
		//영화API 호출을 위한 URI를 생성
		let apiURI = URL(string: "http://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=2748a6f097987ce9a2327cb8f11240c5&targetDt=\(targetDt)")
		
		Alamofire.request(apiURI!).responseJSON { (response) in
			switch response.result {
			case .success(let data):
				let jsonData = JSON(data)
				print(jsonData)
				//데이터 구조에 따라 차례대로 캐스팅하며 읽어온다.
				let boxOfficeResult = jsonData["boxOfficeResult"].dictionaryValue
				let dailyBoxOfficeList =  boxOfficeResult["dailyBoxOfficeList"]?.arrayValue
				
				//테이블 뷰 리스트를 구성할 데이터 형식
				var mvo : MovieVO
				
				if let movieList = dailyBoxOfficeList{
					for movieValue in movieList {
						mvo = MovieVO()
						mvo.movieNm = movieValue["movieNm"].stringValue
						mvo.movieCd = movieValue["movieCd"].stringValue
						mvo.openDt  = movieValue["openDt"].stringValue
						mvo.rankOldAndNew = movieValue["rankOldAndNew"].stringValue
						mvo.rank = movieValue["rank"].stringValue
						mvo.rankInten = movieValue["rankInten"].stringValue
						
						let aAcc = movieValue["audiAcc"].intValue
						let numberFomat = NumberFormatter()
						numberFomat.numberStyle = .decimal
						
						mvo.audiAcc = numberFomat.string(for: aAcc)
						
						let movieId = movieValue["movieCd"].stringValue
						mvo.detail = "http://www.kobis.or.kr/kobis/mobile/mast/mvie/searchMovieDtl.do?movieCd=\(movieId)"
						
						self.list.append(mvo)
					}
				}
				
				let showRange = boxOfficeResult["showRange"]?.stringValue
				self.rankday?.text = "조회날짜 : \(showRange!)"
				self.movieDayTable.reloadData()
			case .failure(let error):
				print(error)
				let alert  = UIAlertController(title: "경고", message: "api 에러", preferredStyle: .alert)
				let cancelAction = UIAlertAction(title: "확인", style: .cancel, handler: {(_) in
					self.performSegue(withIdentifier: "segue_melon", sender: nil)
				})
				alert.addAction(cancelAction)
				self.present(alert, animated: true, completion: nil)
			}
		}
		
		//REST API를 호출
		//let apidata : Data? = try? Data(contentsOf: apiURI!)
		
		//데이터 전송 결과를 로그로 출력(확인용)
		//NSLog("\n <more> API Result = %@", NSString(data: apidata!, encoding: NSUTF8StringEncoding)!)
		
		//JSON 객체를 파싱하여 NSDictionary 객체로 받음
//		do{
//			let apiDictionary = try JSONSerialization.jsonObject(with: apidata!, options: []) as? NSDictionary
//			
//			//데이터 구조에 따라 차례대로 캐스팅하며 읽어온다.
//			let boxOfficeResult = apiDictionary!["boxOfficeResult"] as! NSDictionary
//			let dailyBoxOfficeList =  boxOfficeResult["dailyBoxOfficeList"] as! NSArray
//			
//			//테이블 뷰 리스트를 구성할 데이터 형식
//			var mvo : MovieVO
//			
//			// Iterator 처리를 하면서 API 데이터를 MovieVO객체에 저장한다.
//			for row0 in dailyBoxOfficeList{
//				if let row = row0 as? [String] {
//				mvo = MovieVO()
//				
//				mvo.movieNm = row["movieNm"] as? String
//				mvo.movieCd = row["movieCd"] as? String
//				mvo.openDt  = row["openDt"] as? String
//				mvo.rankOldAndNew = row["rankOldAndNew"] as? String
//				mvo.rank = row["rank"] as? String
//				mvo.rankInten = row["rankInten"] as? String
//				
//				let aAcc = Int((row["audiAcc"] as? String)!)
//				let numberFomat = NumberFormatter()
//				numberFomat.numberStyle = .decimal
//				
//				mvo.audiAcc = numberFomat.string(from: aAcc!)
//				
//				let movieId = row["movieCd"] as? String
//				mvo.detail = "http://www.kobis.or.kr/kobis/mobile/mast/mvie/searchMovieDtl.do?movieCd=\(movieId!)"
//				
//				self.list.append(mvo)
//			}
//			
//			}
//			let showRange = boxOfficeResult["showRange"] as? String
//			self.rankday?.text = "조회날짜 : \(showRange!)"
//			
//		} catch{
//			let alert  = UIAlertController(title: "경고", message: "파싱 에러", preferredStyle: .alert)
//			let cancelAction = UIAlertAction(title: "확인", style: .cancel, handler: {(_) in
//				self.performSegue(withIdentifier: "segue_melon", sender: nil)
//			})
//			alert.addAction(cancelAction)
//			self.present(alert, animated: true, completion: nil)
//			NSLog("Parse Error!!")
//		}//catch end
	}//API end
	
	//=======================================테이블 뷰 구성=====================================================
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		//테이블 뷰 행의 개수를 반환하는 메소드를 재정의한다.
		return self.list.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		//주어진 행에 맞는 데이터 소스를 가져옴
		let row = self.list[indexPath.row]
		
		//NSLog("result = \(row.songName!), row index = \(indexPath.row)")
		
		
		//as! UITableViewCell => as! MovieCell로 캐스팅 타입 변경
		let cell = tableView.dequeueReusableCell(withIdentifier: "dayCell") as! MdayCell!
		
		
		//데이터 소스에 저장된 값을 각 레이블 변수에 할당
		cell?.movieNm?.text = row.movieNm
		cell?.rank?.text = row.rank
		cell?.openDt?.text = row.openDt
		
		
		if Int(row.rankInten!) > 0 {
			cell?.rankInten?.textColor = UIColor.red
			cell?.rankInten?.text = "▲ \(row.rankInten!) / 누적: \(row.audiAcc!)명"
		}else if Int(row.rankInten!) < 0 {
			cell?.rankInten?.textColor = UIColor.blue
			cell?.rankInten?.text = "▼ \(row.rankInten!) / 누적: \(row.audiAcc!)명"
		}else {
			cell?.rankInten?.textColor = UIColor.gray
			cell?.rankInten?.text = "0 / 누적: \(row.audiAcc!)명"
		}
		
		if row.rankOldAndNew == "NEW" {
			cell?.rankOldAndNew?.textColor = UIColor.red
			
		}else if row.rankOldAndNew == "OLD" {
			cell?.rankOldAndNew?.textColor = UIColor.blue
		}else {
			cell?.rankOldAndNew?.textColor = UIColor.gray
		}
		cell?.rankOldAndNew?.text = row.rankOldAndNew
		
		//구성된 셀을 반환함
		return cell!
	}
	
	override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
		//NSLog("Touch Table Row at %d", indexPath.row)
	}
	
} //class end
