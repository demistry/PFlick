//
//  HomeCoordinator.swift
//  PFlick
//
//  Created by David Ilenwabor on 28/08/2020.
//  Copyright © 2020 Davidemi. All rights reserved.
//

import Foundation

class HomeCoordinator: Coordinator{
    var childCoordinators: [Coordinator] = []
    
    var router: Router
    
    weak var parentCoordinator: Coordinator?
    init(router: Router){
        self.router = router
    }
    
    func start() {
        let homeViewController = HomeViewController.instantiate()
        let photosViewModel = PhotosViewModel()
        homeViewController.coordinator = self
        homeViewController.viewModel = photosViewModel
        router.setRootScreen(homeViewController, hideBar: true)
    }
}
