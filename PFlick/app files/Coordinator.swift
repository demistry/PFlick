//
//  Coordinator.swift
//  PFlick
//
//  Created by David Ilenwabor on 28/08/2020.
//  Copyright © 2020 Davidemi. All rights reserved.
//

import Foundation

protocol Coordinator : class{
    var childCoordinators : [Coordinator]{get set}
    var router : Router {get set}
    var parentCoordinator : Coordinator?{get set}
    func start()
    func finish()
    func addChild(_ coordinator : Coordinator)
    func removeChildCoordinator(_ childCoordinator : Coordinator)
    func removeAllChildCoordinators()
}


extension Coordinator{
    
    func addChild(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
        coordinator.parentCoordinator = self
    }
    func removeChildCoordinator(_ coordinator: Coordinator) {
        for (index, coord) in childCoordinators.enumerated() {
            if coord === coordinator {
                childCoordinators.remove(at: index)
                break
            }
        }
    }

    func removeAllChildCoordinators() {
        childCoordinators.removeAll()
    }
    
    func finish(){
        parentCoordinator?.removeChildCoordinator(self)
    }
}
