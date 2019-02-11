//
//  MovieVO.swift
//  Ranklist
//
//  Created by Nebula_MAC on 2016. 1. 9..
//  Copyright © 2016년 Nebula_MAC. All rights reserved.
//

import UIKit
import SwiftyJSON


struct BoxOffice {

    ///해당일자의 박스오피스 순위를 출력합니다.
    let rank: Int

    ///영화명(국문)을 출력합니다.
    let movieNm: String

    ///전일대비 순위의 증감분을 출력합니다.
    let rankInten: Int

    ///랭킹에 신규진입여부를 출력합니다.“OLD” : 기존 ,“NEW” : 신규
    let rankOldAndNew: String

    ///영화의 개봉일을 출력합니다.
    let openDt: String

    ///전일 대비 관객수 증감 비율을 출력합니다.
    let audiChange: Double

    ///누적관객수를 출력합니다.
    let audiAcc: Int64

    ///조회일자에 해당하는 연도와 주차를 출력합니다.(YYYYIW)
    let yearWeekTime: String

    ///누적매출액을 출력합니다.
    let salesAcc: Int64

    ///영화의 대표코드를 출력합니다.
    let movieCd: String
    
    ///관람수
    let showCnt: Int64

    ///검색
    let detail: String

    init(json: JSON) {
        movieNm = json["movieNm"].stringValue
        movieCd = json["movieCd"].stringValue
        openDt = json["openDt"].stringValue
        yearWeekTime = json["yearWeekTime"].stringValue
        rank = json["rank"].intValue
        rankInten = json["rankInten"].intValue
        rankOldAndNew = json["rankOldAndNew"].stringValue
        audiChange = json["audiChange"].doubleValue
        audiAcc = json["audiAcc"].int64Value
        salesAcc = json["salesAcc"].int64Value
        showCnt = json["showCnt"].int64Value

        detail = "http://www.kobis.or.kr/kobis/mobile/mast/mvie/searchMovieDtl.do?movieCd=\(movieCd)"
    }
}

struct MovieVO {
    let boxOfficeType: String
    let showRange: String
    let yearWeekTime: String

    let boxOfficeList: [BoxOffice]
    
    init(data: Any, type: BoxOfficeSearchType) {
        let json = JSON(data)

        let boxOfficeResult = json["boxOfficeResult"]
        boxOfficeType = boxOfficeResult["boxOfficeType"].stringValue
        showRange = boxOfficeResult["showRange"].stringValue
        yearWeekTime = boxOfficeResult["yearWeekTime"].stringValue

        var key: String {
            switch type {
            case .daily:
                return "dailyBoxOfficeList"
            case .weekly:
                return "weeklyBoxOfficeList"
            }
        }
        
        boxOfficeList = boxOfficeResult[key].arrayValue.map {
            BoxOffice(json: $0)
        }
    }
}
