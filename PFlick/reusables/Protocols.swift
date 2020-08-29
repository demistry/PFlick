//
//  Protocols.swift
//  PFlick
//
//  Created by David Ilenwabor on 28/08/2020.
//  Copyright © 2020 Davidemi. All rights reserved.
//

import UIKit


protocol Cellable : class {
    static func identifier()->String
    
    static func nib()->UINib
}

protocol PhotoGridCellLayoutDelegate: class {
  func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat
}

extension Cellable where Self : UICollectionViewCell{
    
    static func identifier()->String{
        return String(describing: Self.self)
    }
    
    static func nib()->UINib{
        return UINib(nibName: String(describing: Self.self), bundle: Bundle.main)
    }
}


