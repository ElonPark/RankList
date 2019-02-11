//
//  MusicVO.swift
//  Ranklist
//
//  Created by Nebula_MAC on 2016. 1. 9..
//  Copyright © 2016년 Nebula_MAC. All rights reserved.
//

import UIKit
import SwiftyJSON

enum MelonChart: String {
    case realtimeChart = "/melon/charts/realtime"
    case newReleasesAlbums = "/melon/newreleases/albums"
}

struct Artist {
    let artistName: String
    
    init(json: JSON) {
        artistName = json["artistName"].stringValue
    }
}

struct Song {
    let songId: Int
    let songName: String
    let isTitleSong: Bool
    let artistName: String
    let albumName: String
    let currentRank : Int
    let pastRank : Int
    let artists: [Artist]
    let detail: String
    
    
    init(json: JSON) {
        songId = json["songId"].intValue
        songName = json["songName"].stringValue
        albumName = json["albumName"].stringValue
        artistName = json["artists"].stringValue
        currentRank = json["currentRank"].intValue
        pastRank = json["pastRank"].intValue
        isTitleSong = json["isTitleSong"].boolValue
        
        let artists = json["artists"]
        self.artists = artists["artist"].arrayValue.map {
            Artist(json: $0)
        }
        
        detail = "http://m.app.melon.com/song/lyrics.htm?songId=\(songId)"
    }
}

struct Album {
    let artistName: String
    let albumId: Int
    let albumName: String
    let issueDate: String
    let averageScore: String
    let totalSongCount : Int
    let artists: [Artist]
    let detail: String
    
    init(json: JSON) {
        albumId = json["albumId"].intValue
        albumName = json["albumName"].stringValue
        artistName = json["artists"].stringValue
        issueDate = json["issueDate"].stringValue
        averageScore = json["averageScore"].stringValue
        totalSongCount = json["totalSongCount"].intValue
        
        let artists = json["repArtists"]
        self.artists = artists["artist"].arrayValue.map {
            Artist(json: $0)
        }
        
        detail = "http://m.app.melon.com/album/music.htm?albumId=\(albumId)"
    }
}

struct MusicVO {
    
    let songs: [Song]
    let albums: [Album]
    
    init(data: Any, type: MelonChart) {
        let json = JSON(data)
        let melon = json["melon"]
        
        switch type {
        case .realtimeChart:
            let songs = melon["songs"]
            self.songs = songs["song"].arrayValue.map {
                Song(json: $0)
            }
            
            albums = [Album]()
            
        case .newReleasesAlbums:
            let albums = melon["albums"]
            self.albums = albums["album"].arrayValue.map {
                Album(json: $0)
            }
            
            songs = [Song]()
        }
    }
}
