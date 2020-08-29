//
//  PhotosViewModel.swift
//  PFlick
//
//  Created by David Ilenwabor on 29/08/2020.
//  Copyright © 2020 Davidemi. All rights reserved.
//

import Foundation
import RxSwift

class PhotosViewModel{
    
    
    var pageNumber: Int = 1
    let disposeBag = DisposeBag()
    func queryForNewPictures(text: String){
        if text == ""{
            return
        }
        var parameters = FlickrRequest.getRootMethodParameters
        parameters["text"] = text
        parameters["page"] = pageNumber
        let request = FlickrRequest(parameters: parameters)
        ApiClient.shared.call(.fetchPictures(request)).subscribe(onSuccess: { (resp) in
            let flickerRes = resp as FlickrResponse
            print("Flicker res received here is \(flickerRes.photos.photo.count)")
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
