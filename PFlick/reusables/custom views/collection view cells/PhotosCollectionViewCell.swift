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
    var isFilterOn = UserDefaults.standard.bool(forKey: Constants.Keys.isFilterOn)
    var photo: PhotosViewData?{
        didSet{
            isFilterOn = UserDefaults.standard.bool(forKey: Constants.Keys.isFilterOn)
            imageViewDisplay.sd_setImage(with: photo?.photoURL.url, placeholderImage: nil) {[weak self] (img, err, cache, url) in
                guard err == nil, let selfVal = self else{
                    return
                }
                self?.photo?.originalImage = img
                if selfVal.isFilterOn{
                    self?.imageViewDisplay.image = img?.addFilter(filterType: selfVal.photo?.filter ?? "")
                } else{
                    self?.imageViewDisplay.image = selfVal.photo?.originalImage
                }
            }
            if isFilterOn{
                self.filterTextBackground.alpha = 1
                self.filterLabelName.text = self.photo?.filter
            } else{
                self.filterLabelName.text = ""
                self.filterTextBackground.alpha = 0
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

