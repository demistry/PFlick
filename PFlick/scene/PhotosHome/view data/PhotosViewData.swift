//
//  PhotosViewData.swift
//  PFlick
//
//  Created by David Ilenwabor on 29/08/2020.
//  Copyright © 2020 Davidemi. All rights reserved.
//

import Foundation
import RxDataSources
import UIKit

class PhotosViewData: IdentifiableType, Equatable{
    
    typealias Identity = UUID
    
    
    static func == (lhs: PhotosViewData, rhs: PhotosViewData) -> Bool {
        return lhs.identity == rhs.identity
    }
    
    private var model: PhotoObject
    init(model: PhotoObject) {
        self.sizeSuffix = String(String.randomElement("qmn")() ?? Character("m"))
        self.model = model
    }
    
    var identity: UUID{
        let uuid = UUID()
        print("UUID \(uuid)")
        return uuid
    }
    
    var heightOfPhoto: Float{
        switch sizeSuffix{
        case "q": return 150
        case "m": return 240
        case "n": return 320
        default: return 180
        }
    }
    
    var originalImage: UIImage?
    
    var filter  = ["CIColorInvert", "CIPhotoEffectNoir", "CIPhotoEffectInstant", "CIMultiplyBlendMode",
    "CIMedianFilter",
    "CIColorMatrix",
    "CIColorPolynomial",
    "CIExposureAdjust",
    "CIGammaAdjust",
    "CINoiseReduction",
    "CIColorMap",
    "CIColorMonochrome",
    "CIColorPosterize",
    "CIFalseColor",
        ].randomElement() ?? "CIColorClamp"
    
    var photoURL: (url: URL?, absoluteString: String){
        let urlString = "https://farm\(model.farm).staticflickr.com/\(model.server)/\(model.id)_\(model.secret)_\(sizeSuffix).jpg"
        print("Size of suffix \(sizeSuffix)")
        return (URL(string: urlString), urlString)
    }
    
    var sizeSuffix: String = "m"
 
}
