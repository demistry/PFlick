//
//  APIEndpoints.swift
//  PFlick
//
//  Created by David Ilenwabor on 28/08/2020.
//  Copyright © 2020 Davidemi. All rights reserved.
//

import Foundation

enum APIEndpoints<T>{
    case fetchPictures(T)
    
    var value: T{
        switch self{
        case .fetchPictures(let val):
            return val
        }
    }
}


enum APIError: Error{
    case responseError
    case decodingError
    case noDataResponse
    case urlParsingError
}
