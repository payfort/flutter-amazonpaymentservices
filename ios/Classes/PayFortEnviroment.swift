//
//  Enviroment.swift
//  PayFort
//
//  Created by Mac OS on 9/16/20.
//  Copyright © 2020 PayFort. All rights reserved.
//

import Foundation

@objc public enum PayFortEnviroment : Int {
    case sandBox
    case production

    var url : String {
        switch self {
        case .sandBox:
            return Constants.sandBox
        case .production:
            return Constants.production
        }
    }
}


