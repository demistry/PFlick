//
//  AnimationUtil.swift
//  PFlick
//
//  Created by David Ilenwabor on 29/08/2020.
//  Copyright © 2020 Davidemi. All rights reserved.
//

import Foundation
import Lottie
import UIKit

class AnimationUtil{
    
    static let shared = AnimationUtil()
    private init(){
        
    }
    
    @discardableResult
    func showEmptyState(onView view : UIView)->AnimationView{
        let emptyStateAnimation = AnimationView(name: Constants.AnimationNames.EmptyState)
        emptyStateAnimation.backgroundColor = .clear
        emptyStateAnimation.makeLayoutable()
        emptyStateAnimation.loopMode = .repeat(.infinity)
        emptyStateAnimation.backgroundBehavior = .pauseAndRestore
        emptyStateAnimation.contentMode = .scaleAspectFit
        view.addSubview(emptyStateAnimation)
        
        NSLayoutConstraint.activate([
            emptyStateAnimation.widthAnchor.constraint(equalTo: view.widthAnchor),
            emptyStateAnimation.heightAnchor.constraint(equalTo: view.heightAnchor),
            emptyStateAnimation.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateAnimation.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        emptyStateAnimation.play()
        return emptyStateAnimation
    }
}
