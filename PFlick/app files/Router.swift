//
//  Router.swift
//  PFlick
//
//  Created by David Ilenwabor on 28/08/2020.
//  Copyright © 2020 Davidemi. All rights reserved.
//

import UIKit

class Router: NSObject, UINavigationControllerDelegate{
    private var navigationController: UINavigationController
    
    var rootNav: UINavigationController{
        return navigationController
    }
    override init() {
        self.navigationController = UINavigationController()
        super.init()
        self.navigationController.delegate = self
        self.navigationController.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController.navigationBar.isHidden = true
    }
    
    func startRouter( window: inout UIWindow){
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func presentScreen(_ viewController: UIViewController, animated: Bool){
        DispatchQueue.main.async {[weak self] in
            self?.navigationController.present(viewController, animated: animated, completion: nil)
        }
    }
    
    func dismissScreen(animated: Bool, completion: (()->Void)? = nil){
        DispatchQueue.main.async {[weak self] in
            self?.navigationController.dismiss(animated: animated, completion: completion)
        }
    }
    
    func pushScreen(_ viewController: UIViewController, animated: Bool, isPopGestureEnabled: Bool = true, isNavBarHidden: Bool = true){
        DispatchQueue.main.async {[weak self] in
            self?.navigationController.pushViewController(viewController, animated: animated)
            self?.navigationController.interactivePopGestureRecognizer?.isEnabled = isPopGestureEnabled
            self?.navigationController.navigationBar.isHidden = isNavBarHidden
        }
    }
    
    func popScreen(animated: Bool, isPopGestureEnabled: Bool = true, isNavBarHidden: Bool = true){
        DispatchQueue.main.async {[weak self] in
            self?.navigationController.popViewController(animated: animated)
            self?.navigationController.interactivePopGestureRecognizer?.isEnabled = isPopGestureEnabled
            self?.navigationController.navigationBar.isHidden = isNavBarHidden
        }
    }
    
    func setRootScreen(_ viewController: UIViewController, hideBar: Bool){
        DispatchQueue.main.async {[weak self] in
            self?.navigationController.setViewControllers([viewController], animated: true)
        }
    }
    
    
    func popToRootScreen(animated: Bool){
        DispatchQueue.main.async {[weak self] in
            self?.navigationController.popToRootViewController(animated: animated)
        }
    }
    
}

