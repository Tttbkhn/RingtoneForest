//
//  NoFillButtonView.swift
//  RingtoneForest
//
//  Created by Thu Trương on 25/06/2023.
//

import SwiftUI

struct NoFillButtonView: View {
    var text: String
    var width: CGFloat
    var height: CGFloat
    var cornerRadius: CGFloat
    var textSize: CGFloat
    var color: ColorAsset
    
    var onTap: () -> ()
    
    var body: some View {
        Button {
            onTap()
        } label: {
            Text(text)
                .modifier(TextModifier(color: color, size: textSize, weight: .bold))
                .frame(width: width, height: height)
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(style: StrokeStyle(lineWidth: 2))
                    .fill(Color(asset: color))
                )
        }

    }
}

struct NoFillButtonView_Previews: PreviewProvider {
    static var previews: some View {
        NoFillButtonView(text: L10n.delete, width: 100, height: 46, cornerRadius: 23, textSize: 14, color: Asset.Colors.colorGray83868A) {
            
        }
    }
}
