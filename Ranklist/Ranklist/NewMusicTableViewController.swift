//
//  NewMusicTableViewController.swift
//  Ranklist
//
//  Created by Nebula_MAC on 2016. 1. 10..
//  Copyright © 2016년 Nebula_MAC. All rights reserved.
//

import UIKit
class NewMusicTableViewContrller : UITableViewController {
    
    @IBOutlet var newMusicTable: UITableView!
    @IBOutlet var moreBtn: UIButton!
    
    //테이블 뷰를 구성할 리스트 데이터를 담을 배열 변수( = [MusicVO]())
    var list = Array<MusicVO>()
    
    //현재까지 읽어온 데이터 정보
    var page = 1

    //초기화면
    override func viewDidLoad() {
        self.callMusicAPI()
    }
    
    //=============================세그웨이=====================================
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //실행된 세그웨이의 식별자가  segue_rtmdetail이라면
        if(segue.identifier == "segue_newdetail") {
            //sender 인자를 캐스팅하여  테이블 셀 객체로 변환한다.
            let cell = sender as! NewreleaseCell
            
            //세그웨이를 실행한 객체 정보를 이용하여 몇 번째 행이 선택되었는지 확인한다.
            let path  = self.newMusicTable.indexPathForCell(cell)
            
            //API 음악 데이터 배열 중에서 선택된 행에 대한 데이터를 얻는다.
            let param = self.list[path!.row]
            
            //세그웨이가 향할 목적지 뷰 컨트롤러 객체를 읽어와 miz 변수에 데이터를 연결해준다.
            (segue.destinationViewController as? RtMusicDetailViewController)?.miz = param
            
        }
    }

    
    //더보기 버튼
    @IBAction func more(sender: AnyObject) {
        //더 많은 노래 목록을 불러오기 위해
        self.page++
        
        //영화차트 API를 호출한다.
        self.callMusicAPI()
        
        //데이터를 다시 읽어오도록 테이블 뷰를 갱신
        self.newMusicTable.reloadData()
    }
    
    
    //음악 API
    func callMusicAPI() {
        //멜론API 호출을 위한 URI를 생성
        let apiURI = NSURL(string:"http://apis.skplanetx.com/melon/newreleases/albums?count=20&page=\(self.page)&version=1&appKey=d9d377f1-756e-3bba-b050-0dc459d349e9")
        
        
        //REST API를 호출
        let apidata : NSData? = NSData(contentsOfURL: apiURI!)
        
        //데이터 전송 결과를 로그로 출력(확인용)
        //NSLog("\n <more> API Result = %@", NSString(data: apidata!, encoding: NSUTF8StringEncoding)!)
        
        //JSON 객체를 파싱하여 NSDictionary 객체로 받음
        do{
            let apiDictionary = try NSJSONSerialization.JSONObjectWithData(apidata!, options: []) as! NSDictionary
            
            //데이터 구조에 따라 차례대로 캐스팅하며 읽어온다.
            let melon = apiDictionary["melon"] as! NSDictionary
            let albums = melon["albums"] as! NSDictionary
            let album = albums["album"] as! NSArray
            
            //테이블 뷰 리스트를 구성할 데이터 형식
            var mzi : MusicVO
            
            // Iterator 처리를 하면서 API 데이터를 MusicVO객체에 저장한다.
            for row in album {
                mzi = MusicVO()
                
                mzi.albumName      = row["albumName"] as? String
                mzi.artistName     = row["artists"] as? String
                mzi.issueDate      = row["issueDate"] as? String
                mzi.totalSongCount = row["totalSongCount"] as? Int
                mzi.averageScore   = row["averageScore"] as? String
                
                let artists = row["repArtists"] as! NSDictionary
                let artist = artists["artist"] as! NSArray
                
                for ro2 in artist {
                    mzi.artistName = ro2["artistName"] as? String
                }
                
                let albumId = row["albumId"] as? Int
                mzi.detail = "http://m.melon.com/cds/common/mobile/openapigate_dispatcher.htm?type=album&cid=\(albumId!)"
                
                self.list.append(mzi)
                
            }
            
            
            //전체 데이터 카운트를 얻는다.
            let totalCount = melon["totalPages"] as? Int
            
            //totalCount가 읽어온 데이터 크기와 같거나 클 경우 더보기 버튼을 막는다.
            if(self.list.count >= totalCount) {
                self.moreBtn.hidden = true
            }
            
        } catch{
            NSLog("Parse Error!!")
        }//catch end
        
    }//API end

    //=======================================테이블 뷰 구성=====================================================
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //테이블 뷰 행의 개수를 반환하는 메소드를 재정의한다.
        return self.list.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //주어진 행에 맞는 데이터 소스를 가져옴
        let row = self.list[indexPath.row]
        
        //NSLog("result = \(row.songName!), row index = \(indexPath.row)")
        
        /*여기서부터 변경 내용 시작*/
        //as! UITableViewCell => as! MovieCell로 캐스팅 타입 변경
        let cell = tableView.dequeueReusableCellWithIdentifier("nmCell") as! NewreleaseCell!
        
        
        //데이터 소스에 저장된 값을 각 레이블 변수에 할당
        cell.albumName?.text = row.albumName
        cell.issueDate?.text = row.issueDate
        cell.countScore?.text = "\(row.totalSongCount!)곡 / 평점:\(row.averageScore!)"
        cell.artistName?.text = row.artistName
        
        //구성된 셀을 반환함
        return cell
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        //NSLog("Touch Table Row at %d", indexPath.row)
    }
    

}