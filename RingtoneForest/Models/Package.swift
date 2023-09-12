//
//  Package.swift
//  RingtoneForest
//
//  Created by Thu Truong on 9/12/23.
//

import Foundation

struct Package {
    var productID: String
    var name: String
    var date: Int
}

enum EPremium: String {
    case week = "week"
    case month = "month"
    case year = "year"
    
    var numOfPackage: Int {
        switch self {
        case .week:
            return 0
        case .month:
            return 1
        case .year:
            return 2
        }
    }
}
