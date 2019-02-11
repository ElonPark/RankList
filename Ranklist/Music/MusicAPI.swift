//
//  MusicAPI.swift
//  Ranklist
//
//  Created by Elon on 12/02/2019.
//  Copyright © 2019 Nebula_MAC. All rights reserved.
//

import Foundation
import Alamofire

struct MelonAPI {
    static func request(to type: MelonChart, with page: Int, completion: @escaping (MusicVO?, Error?) -> Void) {
        var musicVO: MusicVO?
        var error: Error?
        
        var urlComponents = URLComponents(string: "http://apis.skplanetx.com")
        urlComponents?.path = type.rawValue
        urlComponents?.queryItems = [
            URLQueryItem(name: "count", value: "20"),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "version", value: "1"),
            URLQueryItem(name: "appKey", value: SKPLANET_API_KEY)
        ]
        
        guard let url = urlComponents?.url else {
            completion(musicVO, APIError.urlError("URL이 올바르지 않습니다."))
            return
        }
        
        Alamofire.request(url).responseJSON { (response) in
            defer {
                completion(musicVO, error)
            }
            
            switch response.result {
            case .success(let data):
                musicVO = MusicVO(data: data, type: type)
                
            case .failure(let apiError):
                print(apiError.localizedDescription)
                error = apiError
            }
        }
    }
}
