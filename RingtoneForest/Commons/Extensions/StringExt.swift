//
//  StringExt.swift
//  RingtoneForest
//
//  Created by Thu Truong on 7/31/23.
//

import Foundation

extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }
}
