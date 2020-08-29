//
//  PhotosViewModel.swift
//  PFlick
//
//  Created by David Ilenwabor on 29/08/2020.
//  Copyright © 2020 Davidemi. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class PhotosViewModel{
    
    
    var pageNumber: Int = 1
    lazy var photosRelay = BehaviorRelay<ListStates<[PhotosViewData]>>(value: .loadedWithNoItems)
    var photosList = BehaviorRelay<[PhotosViewData]>(value: [])
    let disposeBag = DisposeBag()
    var previousSearchString = ""
    func queryForNewPictures(text: String){
        if text == "" || previousSearchString == text{
            return
        }
        previousSearchString = text
        photosRelay.accept(.loading)
        var parameters = FlickrRequest.getRootMethodParameters
        parameters["text"] = text
        parameters["page"] = pageNumber
        let request = FlickrRequest(parameters: parameters)
        ApiClient.shared.call(.fetchPictures(request)).map({$0.photos.photo.map({PhotosViewData(model: $0)})}).subscribe(onSuccess: { [weak self](resp) in
            if resp.count > 0{
                self?.photosRelay.accept(.receivedItems(resp))
                self?.photosList.accept(resp)
            } else{
                self?.photosRelay.accept(.loadedWithNoItems)
            }
            
        }) { (err) in
            if let error = err as? APIError{
                switch error{
                case .responseError:print("Response error with result")
                default:break
                }
            }
        }.disposed(by: disposeBag)
    }
    
}
