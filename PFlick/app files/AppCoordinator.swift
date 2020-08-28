//
//  AppCoordinator.swift
//  PFlick
//
//  Created by David Ilenwabor on 28/08/2020.
//  Copyright © 2020 Davidemi. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinator{
    var childCoordinators: [Coordinator] = []
    
    weak var parentCoordinator: Coordinator? = nil //has no parent as it is the root coordinator
    
    
    var router : Router
    private var window : UIWindow
    
    init(window : UIWindow?) {
        self.window = window ?? UIWindow(frame: UIScreen.main.bounds)
        self.router = Router()
    }
    
    
    func start() {
        router.startRouter(window: &window)
        let homeCoordinator = HomeCoordinator(router: router)
        addChild(homeCoordinator)
        homeCoordinator.start()
    }
    
}
