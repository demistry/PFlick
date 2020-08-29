//
//  APIRequest.swift
//  PFlick
//
//  Created by David Ilenwabor on 29/08/2020.
//  Copyright © 2020 Davidemi. All rights reserved.
//

import Foundation

protocol ApiRequest : Encodable {
    
    associatedtype ResponseType : Decodable
    
    var resourceName : String{get}
    
    func queryParameters()->String
}

extension ApiRequest{
    func queryParameters()->String{
        return ""
    }
}

