//
//  PhotoGridCellLayout.swift
//  PFlick
//
//  Created by David Ilenwabor on 28/08/2020.
//  Copyright © 2020 Davidemi. All rights reserved.
//

import UIKit

class PhotoGridCellLayout: UICollectionViewLayout {

    weak var delegate: PhotoGridCellLayoutDelegate?


    private let columnNumber = 2
    private let gridPadding: CGFloat = 3

 
    private var layoutCache: [UICollectionViewLayoutAttributes] = []

 
    private var contentHeight: CGFloat = 0

    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
          return 0
        }
        return collectionView.bounds.width
    }

 
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var cvVisibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
      
        for attr in layoutCache {
            if attr.frame.intersects(rect) {
                cvVisibleLayoutAttributes.append(attr)
            }
        }
        return layoutCache
    }
    
    override var collectionViewContentSize: CGSize {
        CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if layoutCache.indices.contains(indexPath.item){
            return layoutCache[indexPath.item]
        } else{
//            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            invalidateLayout()
            return nil
        }
    }
  
    override func prepare() {
  
        guard layoutCache.isEmpty, let collectionView = collectionView, collectionView.numberOfSections > 0 else{
            return
        }
      
        let widthOfCellFrame = contentWidth / CGFloat(columnNumber)
        var horizontalOffset: [CGFloat] = []
        
        for column in 0..<columnNumber {
            horizontalOffset.append(CGFloat(column) * widthOfCellFrame)
        }
        
        var column = 0
        var verticalOffset: [CGFloat] = .init(repeating: 0, count: columnNumber)
          
        
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
             
            let indexPath = IndexPath(item: item, section: 0)
            let photoHeight = delegate?.collectionView(
                collectionView,
                heightForPhotoAtIndexPath: indexPath) ?? 150
            let heightOfCellFrame = photoHeight
            let layoutAttrFrame = CGRect(x: horizontalOffset[column], y: verticalOffset[column], width: widthOfCellFrame, height: heightOfCellFrame)
            let insetFrame = layoutAttrFrame.insetBy(dx: gridPadding, dy: gridPadding)
                
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            layoutCache.append(attributes)
                
            contentHeight = max(contentHeight, layoutAttrFrame.maxY)
            verticalOffset[column] = verticalOffset[column] + heightOfCellFrame
                
            column = column < (columnNumber - 1) ? (column + 1) : 0
        }
    }
  
}
