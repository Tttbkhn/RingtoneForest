//
//  TextModifier.swift
//  RingtoneForest
//
//  Created by Thu Truong on 6/22/23.
//

import SwiftUI

struct TextModifier: ViewModifier {
    var color: ColorAsset
    var size: CGFloat
    var weight: Font.Weight
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color(asset: color))
            .font(.system(size: size, weight: weight))
    }
}
