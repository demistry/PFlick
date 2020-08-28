//
//  Extensions.swift
//  PFlick
//
//  Created by David Ilenwabor on 28/08/2020.
//  Copyright © 2020 Davidemi. All rights reserved.
//

import UIKit

extension UIView{
    func makeLayoutable(){
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension UIViewController{
    @discardableResult
    func hideKeyboardWhenTappedAround()->UITapGestureRecognizer {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        return tap
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
