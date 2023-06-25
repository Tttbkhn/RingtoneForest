//
//  PremiumPlanView.swift
//  RingtoneForest
//
//  Created by Thu Trương on 26/06/2023.
//

import SwiftUI

struct PremiumPlanView: View {
    var body: some View {
        ZStack {
            Image(asset: Asset.Assets.imgBackground)
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Image(asset: Asset.Assets.icClose)
                    
                    Spacer()
                }
                .padding(.bottom, 10)
                
                HStack(spacing: 18) {
                    Text(L10n.ringtonesPro)
                        .modifier(TextModifier(color: Asset.Colors.colorGreen69BE15, size: 35, weight: .bold))
                    
                    Image(asset: Asset.Assets.imgPro)
                }
                .padding(.bottom, 30)
                
                
            }
            .padding(.horizontal, 16)
        }
    }
}

struct PremiumPlanView_Previews: PreviewProvider {
    static var previews: some View {
        PremiumPlanView()
    }
}
