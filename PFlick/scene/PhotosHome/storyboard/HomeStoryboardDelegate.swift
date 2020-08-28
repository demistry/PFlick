//
//  HomeStoryboardDelegate.swift
//  PFlick
//
//  Created by David Ilenwabor on 28/08/2020.
//  Copyright © 2020 Davidemi. All rights reserved.
//

import UIKit

protocol HomeStoryboardDelegate {
    static func instantiate() -> Self
    var coordinator: HomeCoordinator?{get set}
}

extension HomeStoryboardDelegate where Self : UIViewController{
    static func instantiate()->Self{
        let ID = String(describing: self)
        let storyboard = UIStoryboard(name: Constants.StoryboardNames.MainStoryboard, bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: ID)
        return viewController as! Self
    }
    
    var coordinator: HomeCoordinator?{
        return nil
    }
}
