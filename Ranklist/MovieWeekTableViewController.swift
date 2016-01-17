//
//  MovieWeekTableViewController.swift
//  Ranklist
//
//  Created by Nebula_MAC on 2016. 1. 11..
//  Copyright © 2016년 Nebula_MAC. All rights reserved.
//

import UIKit

class MovieWeekTableViewController: UITableViewController {
    
    @IBOutlet var movieWeekTable: UITableView!
    @IBOutlet var rankday: UILabel!
    
    var list = Array<MovieVO>()
    
    
    override func viewDidLoad() {
        callMovieAPI()
    }//viewDidLoad end
    
    
    //=============================세그웨이=====================================
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //실행된 세그웨이의 식별자가  segue_rtmdetail이라면
        if(segue.identifier == "segue_weekdetail") {
            //sender 인자를 캐스팅하여  테이블 셀 객체로 변환한다.
            let cell = sender as! MweekCell
            
            //세그웨이를 실행한 객체 정보를 이용하여 몇 번째 행이 선택되었는지 확인한다.
            let path  = self.movieWeekTable.indexPathForCell(cell)
            
            //API 음악 데이터 배열 중에서 선택된 행에 대한 데이터를 얻는다.
            let param = self.list[path!.row]
            
            //세그웨이가 향할 목적지 뷰 컨트롤러 객체를 읽어와 mvo 변수에 데이터를 연결해준다.
            (segue.destinationViewController as? RtMusicDetailViewController)?.mvo = param
            
        }
    }

    
    //오늘 날짜에서 일요일을 가져온다.
    func getDayOfWeekString() -> String? {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYYMMDD"
        
        let calendar = NSCalendar.currentCalendar()
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let myComponents = myCalendar.components(.Weekday, fromDate: NSDate())
        let weekDay = myComponents.weekday
        
        let sunday : NSDate?
        
        switch weekDay {
        case 1:
            sunday = calendar.dateByAddingUnit(.Day, value: -7, toDate: NSDate(), options: [])
            return dateFormatter.stringFromDate(sunday!)
        case 2:
            sunday = calendar.dateByAddingUnit(.Day, value: -1, toDate: NSDate(), options: [])
            return dateFormatter.stringFromDate(sunday!)
        case 3:
            sunday = calendar.dateByAddingUnit(.Day, value: -2, toDate: NSDate(), options: [])
            return dateFormatter.stringFromDate(sunday!)
        case 4:
            sunday = calendar.dateByAddingUnit(.Day, value: -3, toDate: NSDate(), options: [])
            return dateFormatter.stringFromDate(sunday!)
        case 5:
            sunday = calendar.dateByAddingUnit(.Day, value: -4, toDate: NSDate(), options: [])
            return dateFormatter.stringFromDate(sunday!)
        case 6:
            sunday = calendar.dateByAddingUnit(.Day, value: -5, toDate: NSDate(), options: [])
            return dateFormatter.stringFromDate(sunday!)
        case 7:
            sunday = calendar.dateByAddingUnit(.Day, value: -6, toDate: NSDate(), options: [])
            return dateFormatter.stringFromDate(sunday!)
            
        default:
            return nil
        }//switch end
    }//getDayOfWeekString end
    
    func callMovieAPI() {
        let sunday = getDayOfWeekString()
        
        //영화API 호출을 위한 URI를 생성
        let apiURI = NSURL(string: "http://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchWeeklyBoxOfficeList.json?key=2748a6f097987ce9a2327cb8f11240c5&targetDt=\(sunday!)&weekGb=0")
        
        
        //REST API를 호출
        let apidata : NSData? = NSData(contentsOfURL: apiURI!)
        
        //데이터 전송 결과를 로그로 출력(확인용)
        //NSLog("\n <more> API Result = %@", NSString(data: apidata!, encoding: NSUTF8StringEncoding)!)
        
        //JSON 객체를 파싱하여 NSDictionary 객체로 받음
        do{
            let apiDictionary = try NSJSONSerialization.JSONObjectWithData(apidata!, options: []) as! NSDictionary
            
            //데이터 구조에 따라 차례대로 캐스팅하며 읽어온다.
            let boxOfficeResult = apiDictionary["boxOfficeResult"] as! NSDictionary
            let weeklyBoxOfficeList =  boxOfficeResult["weeklyBoxOfficeList"] as! NSArray
            
            //테이블 뷰 리스트를 구성할 데이터 형식
            var mvo : MovieVO
            
            // Iterator 처리를 하면서 API 데이터를 MovieVO객체에 저장한다.
            for row in weeklyBoxOfficeList{
                mvo = MovieVO()
                
                mvo.movieNm = row["movieNm"] as? String
                mvo.movieCd = row["movieCd"] as? String
                mvo.openDt  = row["openDt"] as? String

                let aAcc = Int((row["audiAcc"] as? String)!)
                let numberFomat = NSNumberFormatter()
                numberFomat.numberStyle = .DecimalStyle

                mvo.audiAcc = numberFomat.stringFromNumber(aAcc!)
                
                
                mvo.audiChange = row["audiChange"] as? String
                mvo.rank = row["rank"] as? String
                
                let movieId = row["movieCd"] as? String
                mvo.detail = "http://www.kobis.or.kr/kobis/mobile/mast/mvie/searchMovieDtl.do?movieCd=\(movieId!)"
                
                self.list.append(mvo)
            }
            
            let showRange = boxOfficeResult["showRange"] as? String
            self.rankday?.text = "조회날짜 : \(showRange!) (월 ~ 금)"
            
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
        
        
        //as! UITableViewCell => as! MovieCell로 캐스팅 타입 변경
        let cell = tableView.dequeueReusableCellWithIdentifier("weekCell") as! MweekCell!
        
        
        //데이터 소스에 저장된 값을 각 레이블 변수에 할당
        cell.movieNm?.text = row.movieNm
        cell.rank?.text = row.rank
        cell.openDt?.text = row.openDt
        
        
        if Double(row.audiChange!) > 0 {
            cell.audiChange?.textColor = UIColor.redColor()
            cell.audiChange?.text = "▲ \(row.audiChange!)%"
        }else if Double(row.audiChange!) < 0 {
            cell.audiChange?.textColor = UIColor.blueColor()
            cell.audiChange?.text = "▼ \(row.audiChange!)%"
        }else {
            cell.audiChange?.textColor = UIColor.grayColor()
            cell.audiChange?.text = "\(row.audiChange)%"
        }
        
        cell.audiAcc?.text = "누적: \(row.audiAcc!)명"
        //구성된 셀을 반환함
        return cell
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        //NSLog("Touch Table Row at %d", indexPath.row)
    }
}//class end
