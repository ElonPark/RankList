//
//  MovieAPI.swift
//  Ranklist
//
//  Created by Elon on 10/02/2019.
//  Copyright © 2019 Nebula_MAC. All rights reserved.
//

import Foundation
import Alamofire

enum BoxOfficeSearchType: String {
    case weekly = "searchWeeklyBoxOfficeList.json"
    case daily = "searchDailyBoxOfficeList.json"
}

struct MovieAPI {
  
    static func searchBoxOffice(type: BoxOfficeSearchType, with dateString: String, completion:  @escaping (MovieVO?, Error?) -> Void) {
        var boxOffice: MovieVO?
        var error: Error?
        
        var queryItems = [
            URLQueryItem(name: "key", value: KOBIS_OPEN_API_KEY),
            URLQueryItem(name: "targetDt", value: dateString),
        ]
        
        if type == .weekly {
            queryItems.append(URLQueryItem(name: "weekGb", value: "0"))
        }
        
        var urlComponents = URLComponents(string: "http://www.kobis.or.kr")
        urlComponents?.path = "/kobisopenapi/webservice/rest/boxoffice/"
        urlComponents?.path += type.rawValue
        urlComponents?.queryItems = queryItems
        
        guard let url = urlComponents?.url else {
            completion(boxOffice, APIError.urlError("URL이 올바르지 않습니다."))
            return
        }
        
        Alamofire.request(url).responseJSON { (response) in
            defer {
                completion(boxOffice, error)
            }
            
            switch response.result {
            case .success(let data):
                boxOffice = MovieVO(data: data, type: type)
                
            case .failure(let apiError):
                print(apiError.localizedDescription)
                error = apiError
            }
        }
    }
}
