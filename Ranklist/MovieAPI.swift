//
//  MovieAPI.swift
//  Ranklist
//
//  Created by Elon on 10/02/2019.
//  Copyright © 2019 Nebula_MAC. All rights reserved.
//

import Foundation
import Alamofire

enum APIError: Error {
    case none
    case dateError(String)
    case urlError(String)
}

struct MovieAPI {
    static func searchWeeklyBoxOffice(with dateString: String, completion:  @escaping (BoxOffice?, Error?) -> Void) {
        var boxOffice: BoxOffice?
        var error: Error?
        
        var urlComponents = URLComponents(string: "http://www.kobis.or.kr")
        urlComponents?.path = "/kobisopenapi/webservice/rest/boxoffice/searchWeeklyBoxOfficeList.json"
        urlComponents?.queryItems = [
            URLQueryItem(name: "key", value: KOBIS_OPEN_API_KEY),
            URLQueryItem(name: "targetDt", value: dateString),
            URLQueryItem(name: "weekGb", value: "0")
        ]
        
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
                boxOffice = BoxOffice(data: data)
                
            case .failure(let apiError):
                print(apiError.localizedDescription)
                error = apiError
            }
        }
    }
}
