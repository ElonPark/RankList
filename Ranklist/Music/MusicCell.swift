//
//  MusicCell.swift
//  Ranklist
//
//  Created by Nebula_MAC on 2016. 1. 9..
//  Copyright © 2016년 Nebula_MAC. All rights reserved.
//

import UIKit

class MusicCell: UITableViewCell {
    
    @IBOutlet var cRank: UILabel!
    @IBOutlet var songName: UILabel!
    @IBOutlet var artist: UILabel!
    @IBOutlet var albumName: UILabel!
    @IBOutlet var pastRank: UILabel!
	@IBOutlet weak var albumImg: UIImageView!
    
    private func setSongNameLabel(with song: Song) {
        if song.isTitleSong {
            songName.text = song.songName
        } else {
            songName.textColor = UIColor.darkGray
            songName.text = song.songName
        }
    }
    
    private func setPastRankLabel(with song: Song) {
        let rank: Int
        
        switch (song.pastRank, song.currentRank) {
        case let (past, current) where past > current:
            pastRank.textColor = UIColor.red
            rank = song.pastRank - song.currentRank
            pastRank.text = "▲\(rank)"
            
        case let (past, current) where past < current:
            pastRank.textColor = UIColor.blue
            rank = song.currentRank - song.pastRank
            pastRank?.text = "▼\(rank)"
        
        default:
            pastRank.textColor = UIColor.gray
            pastRank.text = "-"
        }
    }
    
    func setData(with song: Song) {
        setSongNameLabel(with: song)
        albumName.text = song.albumName
        artist.text = song.artistName
        cRank.text = "\(song.currentRank)"
        setPastRankLabel(with: song)
    }
}
