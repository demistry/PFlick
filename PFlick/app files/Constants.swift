//
//  Constants.swift
//  PFlick
//
//  Created by David Ilenwabor on 28/08/2020.
//  Copyright © 2020 Davidemi. All rights reserved.
//

import UIKit


struct Constants {
    
    struct StoryboardNames{
        static let MainStoryboard = "Main"
    }
    
    struct Keys{
        static let FLICKR_BASE_URL = "https://api.flickr.com/services/rest/"
        static var FLICKR_API_KEY : String{
            let key = Bundle.main.infoDictionary?["FLICKR_API_KEY"] as? String
            assert(key != "", "Flicker api key is empty")
            assert(key != nil, "Flicker api key is nil")
            return key!
        }
        
        static var FLICKR_APP_SECRET : String{
            let key = Bundle.main.infoDictionary?["FLICKR_APP_SECRET"] as? String
            assert(key != "", "Flicker secret key is empty")
            assert(key != nil, "Flicker secret key is nil")
            return key!
        }
        
        static let isFilterOn = "isFilterOn"
    }
    
    struct AnimationNames {
        static let EmptyState = "EmptyState"
    }
    
    struct Images{
        static let CancelIcon = UIImage(named: "cancelIcon")
        static let SearchIcon = UIImage(named: "searchIcon")
    }
}
