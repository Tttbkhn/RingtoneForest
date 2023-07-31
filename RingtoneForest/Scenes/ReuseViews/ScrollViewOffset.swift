//
//  ScrollViewOffset.swift
//  RingtoneForest
//
//  Created by Thu Truong on 7/31/23.
//

import SwiftUI

struct ScrollViewOffsetPreferenceKey: PreferenceKey {
    static var defaultValue = CGFloat.zero
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}


