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

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}

extension Date {
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE dd LLLL"
        return formatter
    }()
    
    var dateFormatted: String {
        return Date.formatter.string(from: self)
    }
    
    static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    var timeFormatted: String {
        return Date.timeFormatter.string(from: self)
    }
}
