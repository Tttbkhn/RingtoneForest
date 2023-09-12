//
//  MyTone.swift
//  RingtoneForest
//
//  Created by Thu Truong on 9/12/23.
//

import Foundation

struct MyTone: Identifiable, Equatable {
    var id = UUID().uuidString
    var name: String
    var fileName: String
    let duration: Double
}
