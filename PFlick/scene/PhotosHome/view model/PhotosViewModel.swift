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
    lazy var photosRelay = BehaviorRelay<ListStates<[PhotosViewData]>>(value: .unknown)
    var photosList = BehaviorRelay<[PhotosViewData]>(value: [])
    let disposeBag = DisposeBag()
    var previousSearchString = ""
    func queryForNewPictures(text: String, isRefresh: Bool = false){
        if text == ""{
            return
        }
        previousSearchString = text
        photosRelay.accept(.loading)
        var parameters = FlickrRequest.getRootMethodParameters
        parameters["text"] = text
        pageNumber = isRefresh ? Int.random(in: 2...10) : 1
        parameters["page"] = pageNumber
        let request = FlickrRequest(parameters: parameters)
        ApiClient.shared.call(.fetchPictures(request)).subscribe(onSuccess: { [weak self](resp) in
            let response = resp.photos.photo.map({PhotosViewData(model: $0)})
            if response.count > 0{
                print("First item here is \(resp.photos.page), respp: \(response[0].photoURL) for page number \(self!.pageNumber)")
                self?.photosRelay.accept(.receivedItems(response))
                self?.photosList.accept(response)
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
