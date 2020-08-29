//
//  ViewController.swift
//  PFlick
//
//  Created by David Ilenwabor on 28/08/2020.
//  Copyright © 2020 Davidemi. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class HomeViewController: UIViewController, HomeStoryboardDelegate {

    weak var coordinator: HomeCoordinator?
    @IBOutlet weak var searchBar: SearchBarView!
    @IBOutlet weak var photosCollectionView: UICollectionView!
    let disposeBag = DisposeBag()
    var array: [Photo] = []
    var viewModel: PhotosViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        photosCollectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 32, right: 16)
        photosCollectionView.register(PhotosCollectionViewCell.nib(), forCellWithReuseIdentifier: PhotosCollectionViewCell.identifier())
        setupCollectionView()
        setupBindings()
    }
    
    func setupCollectionView(){
        if let layout = photosCollectionView?.collectionViewLayout as? PhotoGridCellLayout {
          layout.delegate = self
        }
    }
    func setupBindings(){
        searchBar.textToSearchFor.subscribe(onNext: { [weak self] text in
            self?.viewModel.queryForNewPictures(text: text)
            }).disposed(by: disposeBag)
        photosCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        array = [Photo(image: "01"), Photo(image: "02"), Photo(image: "03"), Photo(image: "04"),Photo(image: "05"), Photo(image: "06"),Photo(image: "07"),Photo(image: "08"),Photo(image: "09"),Photo(image: "10"),Photo(image: "11"),Photo(image: "12"),Photo(image: "13")]
        Observable.just(array).asDriver(onErrorJustReturn: []).drive(photosCollectionView.rx.items(cellIdentifier: PhotosCollectionViewCell.identifier(), cellType: PhotosCollectionViewCell.self)){index,photo,cell in
            cell.photo = photo
        }.disposed(by: disposeBag)
    }
}

extension HomeViewController: PhotoGridCellLayoutDelegate{
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        array[indexPath.item].photo?.size.height ?? 180
    }
}

extension HomeViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
        return CGSize(width: itemSize, height: itemSize)
    }
}

