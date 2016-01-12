//
//  MovieVO.swift
//  Ranklist
//
//  Created by Nebula_MAC on 2016. 1. 9..
//  Copyright © 2016년 Nebula_MAC. All rights reserved.
//

import UIKit

class MovieVO {
    
    //박스오피스 조회 일자를 출력합니다.
    var showRange : String?
    
    //해당일자의 박스오피스 순위를 출력합니다.
    var rank : String?
    
    //영화명(국문)을 출력합니다.
    var movieNm : String?
    
    //전일대비 순위의 증감분을 출력합니다.
    var rankInten : String?
    
    //랭킹에 신규진입여부를 출력합니다.“OLD” : 기존 ,“NEW” : 신규
     var rankOldAndNew : String?
    
    //영화의 개봉일을 출력합니다.
    var openDt : String?
    
    //전일 대비 관객수 증감 비율을 출력합니다.
    var audiChange : String?
    
    //누적관객수를 출력합니다.
    var audiAcc : String?
    
    //조회일자에 해당하는 연도와 주차를 출력합니다.(YYYYIW)
    var yearWeekTime : String?
    
    //누적매출액을 출력합니다.
    var salesAcc : String?
    
    //영화의 대표코드를 출력합니다.
    var movieCd : String?
    
    var detail : String?
    //검색  http://www.kobis.or.kr/kobis/mobile/mast/mvie/searchMovieDtl.do?movieCd=\(movieCd)
}
