//
//  FillButtonView.swift
//  RingtoneForest
//
//  Created by Thu Trương on 25/06/2023.
//

import SwiftUI

struct FillButtonView: View {
    var text: String
    var width: CGFloat
    var height: CGFloat
    var cornerRadius: CGFloat
    var textSize: CGFloat
    var textColor: ColorAsset
    var foregroundColor: ColorAsset
    
    var onTap: () -> ()
    
    var body: some View {
        Button {
            onTap()
        } label: {
            Text(text)
                .modifier(TextModifier(color: textColor, size: textSize, weight: .bold))
                .frame(width: width, height: height)
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color(asset: foregroundColor))
                )
        }

    }
}

struct FillButtonView_Previews: PreviewProvider {
    static var previews: some View {
        FillButtonView(text: L10n.delete, width: 100, height: 46, cornerRadius: 11, textSize: 14, textColor: Asset.Colors.colorBlack, foregroundColor: Asset.Colors.colorGray83868A) {
            
        }
    }
}
