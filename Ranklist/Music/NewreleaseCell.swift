//
//  NewreleaseCell.swift
//  Ranklist
//
//  Created by Nebula_MAC on 2016. 1. 10..
//  Copyright © 2016년 Nebula_MAC. All rights reserved.
//

import UIKit

class NewreleaseCell: UITableViewCell {
    
    @IBOutlet var albumName: UILabel!
    @IBOutlet var artistName: UILabel!
    @IBOutlet var countScore: UILabel!
    @IBOutlet var issueDate: UILabel!
    
    func setData(with album: Album)  {
        //데이터 소스에 저장된 값을 각 레이블 변수에 할당
        albumName.text = album.albumName
        issueDate.text = album.issueDate
        countScore.text = "\(album.totalSongCount)곡 / 평점:\(album.averageScore)"
        artistName.text = album.artistName
    }
}
