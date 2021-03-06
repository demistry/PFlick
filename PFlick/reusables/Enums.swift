//
//  Enums.swift
//  PFlick
//
//  Created by David Ilenwabor on 28/08/2020.
//  Copyright © 2020 Davidemi. All rights reserved.
//

import Foundation

enum ListStates<T>{
    
    case loading
    case loadedWithNoItems
    case receivedItems(T)
    case failed(String)
    case unknown
}
