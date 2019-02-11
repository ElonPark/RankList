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
        
        let cancelAction = UIAlertAction(title: "확인", style: .cancel) { [weak self] _ in
            self?.performSegue(withIdentifier: "segue_melon", sender: nil)
        }
        
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func callMovieAPI(with date: String) {
        MovieAPI.searchBoxOffice(type: .weekly, with: date) { [weak self] (boxOfficeData, apiError) in
            defer {
                self?.errorAlert(apiError)
            }
            
            guard let boxOffice = boxOfficeData else { return }
            self?.list = boxOffice.boxOfficeList
            self?.rankday?.text = "조회날짜: \(boxOffice.showRange)"
            self?.movieWeekTable.reloadData()
        }
    }
}

extension MovieWeekTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //테이블 뷰 행의 개수를 반환하는 메소드를 재정의한다.
        return list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "weekCell") as! MweekCell
        
        let data = list[indexPath.row]
        cell.setUI(with: data)
    
        return cell
        
    }
}

class MovieWeekTableViewController: UITableViewController {
	
	@IBOutlet var movieWeekTable: UITableView!
	@IBOutlet var rankday: UILabel!
	
	var list = [BoxOffice]()

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
        
		let detailWebView = segue.destination as? DetailWebViewController
		detailWebView?.mvo = list[path.row]
	}
}
