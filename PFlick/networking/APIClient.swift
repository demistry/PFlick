//
//  APIClient.swift
//  PFlick
//
//  Created by David Ilenwabor on 29/08/2020.
//  Copyright © 2020 Davidemi. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON

class ApiClient{
    
    static let shared = ApiClient()
    private var configuration : URLSessionConfiguration
    private var session : URLSession
    private var decoder : JSONDecoder
    
    private init(){
        configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = ["Content-Type": "application/json; charset=utf-8"]
        session = URLSession(configuration: configuration)
        decoder = JSONDecoder()
    }
    
    typealias NetworkCallAync = (_ success: @escaping (Decodable) -> (), _ failure: @escaping (APIError?) -> ()) -> ()
    private func retryCall(for attempt: Int, after seconds: Int, task: @escaping () -> NetworkCallAync, success: @escaping (Decodable) -> (), failure: @escaping (Error?) -> ()) {
        weak var wSelf = self
        task()(success, { error in
            if attempt <= 0 {
                failure(error)
                return
            }
            DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(seconds)) {
                wSelf?.retryCall(for: attempt - 1, after: seconds , task: task, success: success, failure: failure)
            }
        })
    }
    
    func call<T>(_ endpoint: APIEndpoints<T>)->Single<T.ResponseType> where T: ApiRequest{
        let weakSelf = self
        return Single<T.ResponseType>.create { (single) in
            weakSelf.retryCall(for: 1, after: 5, task: {
                return {success, failure in
                    if let url = URL(string: endpoint.value.resourceName){
                        
                        var httpRequest = URLRequest(url: url)
                        httpRequest.httpMethod = "POST"
                        
                        let task = weakSelf.session.dataTask(with: httpRequest) { (data, response, error) in
                            
                            
                            guard error == nil else{
                                failure(.responseError)
                                return
                            }
                            guard let data = data else{
                                failure(.noDataResponse)
                                return
                            }
                            let res = JSON(data)
                            print("repsonse is \(res) from url")
                            do{
                                let responseData = try weakSelf.decoder.decode(T.ResponseType.self, from: data)
                                success(responseData)

                            }catch{
                                print("Error in decoding \(error.localizedDescription)")
                                failure(.decodingError)
                            }
                        }
                        task.resume()
                    } else{
                        print("Cant parse url")
                        failure(.urlParsingError)
                    }
                }
            }, success: { (resp) in
                if let resp = resp as? T.ResponseType{
                    single(.success(resp))
                }
            }) { (err) in
                if let err = err as? APIError{
                    single(.error(err))
                }
            }
            return Disposables.create()
        }
    }
}


