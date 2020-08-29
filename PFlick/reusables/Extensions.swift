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

extension UIColor {
    static let offWhite = UIColor.init(red: 225/255, green: 225/255, blue: 235/255, alpha: 1)
}

extension UIImage {
    func addFilter(filterType: String)-> UIImage? {
        guard let currentFilter = CIFilter(name: filterType) else { return nil }
        currentFilter.setValue(CIImage(image: self), forKey: kCIInputImageKey)
        let imageContext = CIContext(options: nil)
        if let output = currentFilter.outputImage,
            let cgImage = imageContext.createCGImage(output, from: output.extent) {
            return UIImage(cgImage: cgImage, scale: UIScreen.main.scale, orientation: imageOrientation)
        }
        return nil
    }
}
