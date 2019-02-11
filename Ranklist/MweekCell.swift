//
//  MweekCell.swift
//  Ranklist
//
//  Created by Nebula_MAC on 2016. 1. 11..
//  Copyright © 2016년 Nebula_MAC. All rights reserved.
//

import UIKit

class MweekCell: UITableViewCell {
  
    @IBOutlet var rank: UILabel!
    @IBOutlet var movieNm: UILabel!
    @IBOutlet var openDt: UILabel!
    @IBOutlet var audiAcc: UILabel!
    @IBOutlet var audiChange: UILabel!
    
    private func numberFomat(by data: Any) -> String {
        let numberFomat = NumberFormatter()
        numberFomat.numberStyle = .decimal
        
        return numberFomat.string(for: data) ?? "0"
    }
    
    private func setAudiChangeLabel(by change: Double) {
        let comma = numberFomat(by: change)
        
        if change > 0.0 {
            audiChange.textColor = UIColor.red
            audiChange.text = "▲ \(comma)%"
            
        }else if change < 0.0 {
            audiChange.textColor = UIColor.blue
            audiChange.text = "▼ \(comma)%"
            
        }else {
            audiChange.textColor = UIColor.gray
            audiChange.text = "\(comma)%"
        }
    }
    
    func setUI(with boxOffice: BoxOffice) {
        //데이터 소스에 저장된 값을 각 레이블 변수에 할당
        movieNm.text = boxOffice.movieNm
        rank.text = String(boxOffice.rank)
        openDt.text = boxOffice.openDt
        audiAcc.text = "누적: \(numberFomat(by: boxOffice.audiAcc))명"
        setAudiChangeLabel(by: boxOffice.audiChange)
    }
}
