//
//  MdayCell.swift
//  Ranklist
//
//  Created by Nebula_MAC on 2016. 1. 11..
//  Copyright © 2016년 Nebula_MAC. All rights reserved.
//

import UIKit

class MdayCell: UITableViewCell {
    
    @IBOutlet var rank: UILabel!
    @IBOutlet var movieNm: UILabel!
    @IBOutlet var openDt: UILabel!
    @IBOutlet var rankInten: UILabel!
    @IBOutlet var rankOldAndNew: UILabel!
    
    private func numberFomat(by data: Any) -> String {
        let numberFomat = NumberFormatter()
        numberFomat.numberStyle = .decimal
        
        return numberFomat.string(for: data) ?? "0"
    }
    
    private func setRankOldAndNewLabel(by data: String) {
        switch data {
        case "NEW":
            rankOldAndNew.textColor = UIColor.red
            
        case "OLD":
            rankOldAndNew.textColor = UIColor.blue
            
        default:
            rankOldAndNew.textColor = UIColor.gray
        }
        
        rankOldAndNew.text = data
    }
    
    private func setRankIntenLabel(by boxOffice: BoxOffice) {
        let audiAcc = numberFomat(by: boxOffice.audiAcc)
        
        switch boxOffice.rankInten {
        case _ where boxOffice.rankInten > 0:
            rankInten.textColor = UIColor.red
            rankInten.text = "▲ \(boxOffice.rankInten) / 누적: \(audiAcc)명"
        
        case _ where boxOffice.rankInten < 0:
            rankInten.textColor = UIColor.blue
            rankInten.text = "▼ \(boxOffice.rankInten) / 누적: \(audiAcc)명"
            
        default:
            rankInten.textColor = UIColor.darkGray
            rankInten.text = "0 / 누적: \(audiAcc)명"
        }
    }
    
    func setUI(with boxOffice: BoxOffice) {
        movieNm.text = boxOffice.movieNm
        rank.text = String(boxOffice.rank)
        openDt.text = boxOffice.openDt
        setRankOldAndNewLabel(by: boxOffice.rankOldAndNew)
        setRankIntenLabel(by: boxOffice)
        
    }
}
