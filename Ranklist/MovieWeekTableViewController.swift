//
//  MovieWeekTableViewController.swift
//  Ranklist
//
//  Created by Nebula_MAC on 2016. 1. 11..
//  Copyright © 2016년 Nebula_MAC. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


extension MovieWeekTableViewController {
    
    ///오늘 날짜에서 지난 주 일요일을 가져온다.
    func previousSundayDateString() -> String? {
        guard let sunday = Date.today().previous(.sunday, considerToday: true) else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        
        let sundayString = dateFormatter.string(from: sunday)
        
        return sundayString
    }
    
    
    func errorAlert(_ error: Error?) {
        guard let _error = error else { return }
        let errorString = _error.localizedDescription
        
        let alert  = UIAlertController(title: "Error",
                                       message: errorString,
                                       preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "확인", style: .cancel, handler: {(_) in
            self.performSegue(withIdentifier: "segue_melon", sender: nil)
        })
        
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func callMovieAPI(with date: String) {
        MovieAPI.searchWeeklyBoxOffice(with: date) { [weak self] (boxOfficeData, apiError) in
            defer {
                self?.errorAlert(apiError)
            }
            
            guard let boxOffice = boxOfficeData else { return }
            self?.list = boxOffice.weeklyBoxOfficeList
            self?.rankday?.text = "조회날짜: \(boxOffice.showRange)"
            self?.movieWeekTable.reloadData()
            
        }
    }
}

extension MovieWeekTableViewController {
    
    func setData(to cell: MweekCell, by row: WeeklyBoxOffice) -> MweekCell {
        //데이터 소스에 저장된 값을 각 레이블 변수에 할당
        cell.movieNm.text = row.movieNm
        cell.rank.text = String(row.rank)
        cell.openDt.text = row.openDt
        
        let numberFomat = NumberFormatter()
        numberFomat.numberStyle = .decimal
        cell.audiAcc.text = numberFomat.string(for: row.audiAcc)
        
        if row.audiChange > 0.0 {
            cell.audiChange.textColor = UIColor.red
            cell.audiChange.text = "▲ \(row.audiChange)%"
            
        }else if row.audiChange < 0.0 {
            cell.audiChange.textColor = UIColor.blue
            cell.audiChange.text = "▼ \(row.audiChange)%"
            
        }else {
            cell.audiChange.textColor = UIColor.gray
            cell.audiChange.text = "\(row.audiChange)%"
        }
        
        cell.audiAcc.text = "누적: \(row.audiAcc)명"
        
        //구성된 셀을 반환함
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //테이블 뷰 행의 개수를 반환하는 메소드를 재정의한다.
        return list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let row = list[indexPath.row]
    
        var cell = tableView.dequeueReusableCell(withIdentifier: "weekCell") as! MweekCell
        
        cell = setData(to: cell, by: row)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("Touch Table Row at \(indexPath.row)")
    }
}

class MovieWeekTableViewController: UITableViewController {
	
	@IBOutlet var movieWeekTable: UITableView!
	@IBOutlet var rankday: UILabel!
	
	var list = [WeeklyBoxOffice]()

	override func viewDidLoad() {
        if let sunday = previousSundayDateString() {
            callMovieAPI(with: sunday)
        } else {
            errorAlert(APIError.dateError("날짜가 올바르지 않습니다."))
        }
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard segue.identifier == "segue_weekdetail" else { return }
		guard  let cell = sender as? MweekCell else { return }
		guard let path = movieWeekTable.indexPath(for: cell) else { return }
		//API 음악 데이터 배열 중에서 선택된 행에 대한 데이터를 얻는다.
		let param = self.list[path.row]
		//세그웨이가 향할 목적지 뷰 컨트롤러 객체를 읽어와 mvo 변수에 데이터를 연결해준다.
		let detailWebView = segue.destination as? DetailWebViewController
		detailWebView?.mvo = param
	}
}
