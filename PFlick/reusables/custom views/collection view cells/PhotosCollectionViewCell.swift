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
    
    @IBOutlet weak var filterTextBackground: UIView!
    @IBOutlet weak var filterLabelName: UILabel!
    @IBOutlet weak var imageViewDisplay: UIImageView!
    var indexPath: IndexPath!
    weak var delegate: PhotoCollectionViewCellDelegate?
    let isFilterOn = UserDefaults.standard.bool(forKey: Constants.Keys.isFilterOn)
    var photo: PhotosViewData!{
        didSet{
            imageViewDisplay.sd_setImage(with: photo.photoURL.url, placeholderImage: nil) {[weak self] (img, err, cache, url) in
                guard err == nil else{
                    return
                }
                self?.photo.originalImage = img
                self?.imageViewDisplay.image = self?.isFilterOn ?? false ? img?.addFilter(filterType: self?.photo.filter ?? "") : img
                self?.filterLabelName.text = self?.isFilterOn ?? false ? self?.photo.filter : ""
                self?.filterTextBackground.alpha = self?.isFilterOn ?? false ? 1 : 0
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
        
        filterLabelName.text = isFilterOn ? self.photo.filter : ""
        filterTextBackground.alpha = isFilterOn ? 1 : 0
    }

}

