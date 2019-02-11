//
//  APIError.swift
//  Ranklist
//
//  Created by Elon on 11/02/2019.
//  Copyright © 2019 Nebula_MAC. All rights reserved.
//

import Foundation

enum APIError: Error {
    case none
    case dateError(String)
    case urlError(String)
}
