//
//  DateExt.swift
//  RingtoneForest
//
//  Created by Thu Truong on 9/12/23.
//

import Foundation

extension Date {
    func adding(_ component: Calendar.Component, value: Int, using calender: Calendar = .current) -> Date {
        calender.date(byAdding: component, value: value, to: self)!
    }
}
