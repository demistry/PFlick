//
//  PFlickTests.swift
//  PFlickTests
//
//  Created by David Ilenwabor on 28/08/2020.
//  Copyright © 2020 Davidemi. All rights reserved.
//

import XCTest
@testable import PFlick

class PFlickTests: XCTestCase {

    var viewModel: PhotosViewModel!
    var data = FlickrRequest(parameters: [:])
    override func setUpWithError() throws {
        viewModel = PhotosViewModel()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    func testQueryString(){
        data = FlickrRequest(parameters: [:])
        XCTAssert(data.queryString == "")
        data = FlickrRequest(parameters: ["api":"key"])
        XCTAssert(data.queryString == "?api=key")
        data = FlickrRequest(parameters: ["api":"key", "met":"res"])
        XCTAssert(data.queryString == "?api=key&met=res" || data.queryString == "?met=res&api=key")
    }
    
    func testPhotoURL(){
        let photoVD = PhotosViewData(model: PhotoObject(id: "1418878", owner: "b", title: "t", farm: 1, server: "2", secret: "1e92283336"))
        let roughPhotoURL = "https://farm1.staticflickr.com/2/1418878_1e92283336_\(photoVD.sizeSuffix).jpg"
        XCTAssert(photoVD.photoURL.absoluteString == roughPhotoURL)
    }
    
    func testInitialPageNumber(){
        XCTAssert(viewModel.pageNumber == 1)
    }

}
