//
//  DoubleExt.swift
//  RingtoneForest
//
//  Created by Thu Truong on 7/31/23.
//

import Foundation

extension Double {
    func asString() -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        
        var time = formatter.string(from: self) ?? ""
        if time.prefix(2) == "00" {
            time = time.substring(from: 3)
        }
        return time
    }
    
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
}
