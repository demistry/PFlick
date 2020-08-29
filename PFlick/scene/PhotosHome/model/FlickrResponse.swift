//
//  FlickrResponse.swift
//  PFlick
//
//  Created by David Ilenwabor on 29/08/2020.
//  Copyright © 2020 Davidemi. All rights reserved.
//

import Foundation

struct FlickrRequest: ApiRequest{
    var resourceName: String{
//        return "https://api.flickr.com/services/rest/?api_key=e652c8b37021c8354c0dfd0076c13806&method=flickr.photos.search&text=Dog&page=1&per_page=10&format=json"
        return Constants.Keys.FLICKR_BASE_URL + queryString
    }
    
    static var getRootMethodParameters: [String:Any] = [
        "api_key" : Constants.Keys.FLICKR_API_KEY,
        "method" : "flickr.photos.search",
        "per_page" : 25,
        "nojsoncallback" : 1,
        "format" : "json",
        ] as [String: Any]
    
    var queryString: String = ""
    
    typealias ResponseType = FlickrResponse
    
    init(parameters: [String:Any]) {
        queryString = queryParameters(parameters: parameters)
    }
    
    func queryParameters(parameters: [String:Any])->String{
        if parameters.isEmpty{
            return ""
        }
        else{
            var keyValuePairs = [String]() //array of strings
            
            for (key, value) in parameters{
                let stringValue = "\(value)"
                let escapedValue = stringValue.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
                
                keyValuePairs.append(key + "=" + "\(escapedValue!)")
            }
            return "?\(keyValuePairs.joined(separator: "&" ))"
        }
    }
    
}

struct FlickrResponse: Decodable {
    var photos: PhotosDict
}

struct PhotosDict: Decodable{
    var page: Int
    var pages: Int
    var photo: [PhotoObject]
}

struct PhotoObject: Decodable{
    var id: String
    var owner: String
    var title: String
    var farm: Int
    var server: String
    var secret: String
}
