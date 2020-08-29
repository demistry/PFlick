//
//  PhotosCollectionViewCell.swift
//  PFlick
//
//  Created by David Ilenwabor on 28/08/2020.
//  Copyright © 2020 Davidemi. All rights reserved.
//

import UIKit
import SDWebImage


protocol PhotoCollectionViewCellDelegate: class {
    func reloadCell(cell: PhotosCollectionViewCell, imageHeight: CGFloat, indexPath: IndexPath)
}
class PhotosCollectionViewCell: UICollectionViewCell, Cellable {
    @IBOutlet weak var container: UIView!
    
    @IBOutlet weak var imageViewDisplay: UIImageView!
    var indexPath: IndexPath!
    weak var delegate: PhotoCollectionViewCellDelegate?
    var photo: PhotosViewData!{
        didSet{
            imageViewDisplay.sd_setImage(with: photo.photoURL.url, placeholderImage: nil) {[weak self] (img, err, cache, url) in
                guard err == nil else{
                    return
                }
                self?.imageViewDisplay.image = img
                self?.delegate?.reloadCell(cell: self ?? PhotosCollectionViewCell(), imageHeight: img?.size.height ?? 180, indexPath: self?.indexPath ?? IndexPath(item: 0, section: 0))
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageViewDisplay.backgroundColor = UIColor(red: 0.18, green: 0.18, blue: 0.18, alpha: 1)
        imageViewDisplay.layer.cornerRadius = 6
        imageViewDisplay.layer.masksToBounds = true
        imageViewDisplay.contentMode = .scaleAspectFill
    }

}

