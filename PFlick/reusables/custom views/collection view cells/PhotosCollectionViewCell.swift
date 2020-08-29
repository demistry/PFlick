//
//  PhotosCollectionViewCell.swift
//  PFlick
//
//  Created by David Ilenwabor on 28/08/2020.
//  Copyright © 2020 Davidemi. All rights reserved.
//

import UIKit
import SDWebImage

class PhotosCollectionViewCell: UICollectionViewCell, Cellable {
    @IBOutlet weak var container: UIView!
    
    @IBOutlet weak var imageViewDisplay: UIImageView!
    var photo: Photo!{
        didSet{
//            imageViewDisplay.sd_setImage(with: URL, completed: )
            imageViewDisplay.image = photo.photo
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageViewDisplay.layer.cornerRadius = 6
        imageViewDisplay.layer.masksToBounds = true
        imageViewDisplay.contentMode = .scaleAspectFill
    }

}

struct Photo{
    var image: String
    
    var photo: UIImage?{
        return UIImage(named: image)
    }
}
