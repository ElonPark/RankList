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

extension MovieDayTableViewController {
    
    func yesterdayString() -> String? {
        let _yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        
        guard let yesterday = _yesterday else { return nil }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        
        let targetDt = dateFormatter.string(from: yesterday)
        
        return targetDt
    }
    
    func errorAlert(_ error: Error?) {
        guard let _error = error else { return }
        let errorString = _error.localizedDescription
        
        let alert  = UIAlertController(title: "Error",
                                       message: errorString,
                                       preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "확인", style: .cancel) { [weak self] _ in
            self?.performSegue(withIdentifier: "segue_melon", sender: nil)
        }
        
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    ///영화 API
    func callMovieAPI(with date: String) {
        MovieAPI.searchBoxOffice(type: .daily, with: date) { [weak self] (boxOfficeData, apiError) in
            defer {
                self?.errorAlert(apiError)
            }
            
            guard let boxOffice = boxOfficeData else { return }
            self?.list = boxOffice.weeklyBoxOfficeList
            self?.rankday?.text = "조회날짜: \(boxOffice.showRange)"
            self?.movieDayTable.reloadData()
        }
    }
}

extension MovieDayTableViewController {
   
    func setData(to cell: MdayCell, by row: BoxOffice) -> MdayCell {
        //데이터 소스에 저장된 값을 각 레이블 변수에 할당
        cell.movieNm.text = row.movieNm
        cell.rank.text = String(row.rank)
        cell.openDt.text = row.openDt
        
        if row.rankInten > 0 {
            cell.rankInten.textColor = UIColor.red
            cell.rankInten.text = "▲ \(row.rankInten) / 누적: \(row.audiAcc)명"
            
        } else if row.rankInten < 0 {
            cell.rankInten.textColor = UIColor.blue
            cell.rankInten.text = "▼ \(row.rankInten) / 누적: \(row.audiAcc)명"
            
        }else {
            cell.rankInten.textColor = UIColor.gray
            cell.rankInten.text = "0 / 누적: \(row.audiAcc)명"
        }
        
        if row.rankOldAndNew == "NEW" {
            cell.rankOldAndNew.textColor = UIColor.red
            
        }else if row.rankOldAndNew == "OLD" {
            cell.rankOldAndNew.textColor = UIColor.blue
            
        }else {
            cell.rankOldAndNew.textColor = UIColor.gray
        }
        
        cell.rankOldAndNew.text = row.rankOldAndNew
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //테이블 뷰 행의 개수를 반환하는 메소드를 재정의한다.
        return list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //주어진 행에 맞는 데이터 소스를 가져옴
        let row = list[indexPath.row]
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "dayCell") as! MdayCell
        
        cell = setData(to: cell, by: row)
        
       return cell
    }
}

class MovieDayTableViewController: UITableViewController {
	
	@IBOutlet var movieDayTable: UITableView!
	@IBOutlet var rankday: UILabel!
	
	var list = [BoxOffice]()
	
	override func viewDidLoad() {
        if let yesterday = yesterdayString() {
            callMovieAPI(with: yesterday)
        } else {
            errorAlert(APIError.dateError("날짜가 올바르지 않습니다."))
        }
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "segue_daydetail" else { return }
        guard  let cell = sender as? MdayCell else { return }
        guard let path = movieDayTable.indexPath(for: cell) else { return }
        
        let detailWebView = segue.destination as? DetailWebViewController
        detailWebView?.mvo = list[path.row]
	}
}
