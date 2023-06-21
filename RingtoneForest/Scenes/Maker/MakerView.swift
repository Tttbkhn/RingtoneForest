//
//  MakerView.swift
//  RingtoneForest
//
//  Created by Thu Truong on 6/21/23.
//

import SwiftUI

struct MakerView: View {
    var body: some View {
        ZStack {
            Image(asset: Asset.Assets.imgBackground)
                .resizable()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack(spacing: 10) {
                    Image(asset: Asset.Assets.icTunes)
                    Text(L10n.appName)
                        .foregroundColor(Color(asset: Asset.Colors.colorGreen69BE15))
                        .font(.system(size: 30, weight: .bold))
                    
                    Spacer()
                    Image(asset: Asset.Assets.icCrown)
                }
                .padding(.top, 28)
                
                Spacer()
            }
            .padding(.horizontal, 16)
        }
    }
}

struct MakerView_Previews: PreviewProvider {
    static var previews: some View {
        MakerView()
    }
}
