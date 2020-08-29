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
import RxDataSources

class HomeViewController: UIViewController, HomeStoryboardDelegate {

    weak var coordinator: HomeCoordinator?
    @IBOutlet weak var searchBar: SearchBarView!
    @IBOutlet weak var photosCollectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var filterSwitch: UISwitch!
    @IBOutlet weak var emptyStateView: UIView!
    @IBOutlet weak var lottieAnimationView: UIView!
    @IBOutlet weak var emptyStateDescr: UILabel!
    let disposeBag = DisposeBag()
    var viewModel: PhotosViewModel!
    typealias PhotoSectionModel = AnimatableSectionModel<String, PhotosViewData>
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        photosCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
        photosCollectionView.register(PhotosCollectionViewCell.nib(), forCellWithReuseIdentifier: PhotosCollectionViewCell.identifier())
        setupBindings()
        setupCollectionView()
    }
    
    func setupCollectionView(){
        if let layout = photosCollectionView?.collectionViewLayout as? PhotoGridCellLayout {
          layout.delegate = self
        }
        let refreshView = UIRefreshControl()
        refreshView.tintColor = UIColor(red: 0.18, green: 0.18, blue: 0.18, alpha: 1)
        refreshView.addTarget(self, action: #selector(refresh), for: .valueChanged)
        photosCollectionView.refreshControl = refreshView
    }
    
    @objc func refresh(){
        viewModel.queryForNewPictures(text: searchBar.textToSearchFor.value, isRefresh: true)
    }

    func setupBindings(){
        AnimationUtil.shared.showEmptyState(onView: lottieAnimationView)
        filterSwitch.isOn = UserDefaults.standard.bool(forKey: Constants.Keys.isFilterOn)
        filterSwitch.rx.isOn.bind {[weak self] (isOn) in
            UserDefaults.standard.set(isOn, forKey: Constants.Keys.isFilterOn)
            self?.photosCollectionView.reloadData()
        }.disposed(by: disposeBag)
        
        searchBar.textToSearchFor.subscribe(onNext: { [weak self] text in
            self?.viewModel.queryForNewPictures(text: text)
            }).disposed(by: disposeBag)
        photosCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        let dataSource = RxCollectionViewSectionedAnimatedDataSource<PhotoSectionModel>( configureCell: { x, collectionView, indexPath, model in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCollectionViewCell.identifier(), for: indexPath) as? PhotosCollectionViewCell else{
                return UICollectionViewCell()
            }
            cell.indexPath = indexPath
            cell.photo = model
            return cell
            })

        viewModel.photosRelay.asDriver().drive(onNext: {[weak self]state in
            switch state{
            case .loading:
                self?.activityIndicator.startAnimating()
                self?.filterSwitch.isEnabled = false
                break
            case .loadedWithNoItems:
                self?.activityIndicator.stopAnimating()
                self?.photosCollectionView.refreshControl?.endRefreshing()
                self?.emptyStateView.alpha = 1
                self?.emptyStateDescr.text = "Oops, no available picture for the keyword \(self?.searchBar.textToSearchFor.value ?? "")"
                break
            case .receivedItems(_):
                self?.activityIndicator.stopAnimating()
                self?.photosCollectionView.refreshControl?.endRefreshing()
                self?.filterSwitch.isEnabled = true
                self?.emptyStateView.alpha = 0
                break
            case .unknown:
                self?.activityIndicator.stopAnimating()
                self?.photosCollectionView.refreshControl?.endRefreshing()
            }
            }).disposed(by: disposeBag)
        
        viewModel.photosList
            .asDriver()
        .distinctUntilChanged()
            .map({[PhotoSectionModel(model: "", items: $0)]})
            .drive(photosCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
            
    }
    

}

extension HomeViewController: PhotoGridCellLayoutDelegate{
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        CGFloat(viewModel.photosList.value[indexPath.item].heightOfPhoto)
    }
}

extension HomeViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
        return CGSize(width: itemSize, height: itemSize)
    }
}


