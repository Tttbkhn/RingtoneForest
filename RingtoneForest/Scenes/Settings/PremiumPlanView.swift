//
//  PremiumPlanView.swift
//  RingtoneForest
//
//  Created by Thu Trương on 26/06/2023.
//

import SwiftUI

struct PremiumPlanView: View {
    @State var priceWeek = ""
    @State var priceMonth = ""
    @State var priceYear = ""
    
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
                
                VStack(alignment: .leading) {
                    PremiumTextView(text: L10n.unlimited1)
                    PremiumTextView(text: L10n.unlimited2)
                    PremiumTextView(text: L10n.unlimited3)
                    PremiumTextView(text: L10n.removeAds)
                }
                
                Spacer()
                
                HStack(spacing: 11) {
                    VStack {
                        
                    }
                }
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

struct PremiumTextView: View {
    var text: String
    var body: some View {
        HStack {
            Image(asset: Asset.Assets.icSmallCrown)
            
            Text(text)
                .modifier(TextModifier(color: Asset.Colors.colorGrayBCBCBC, size: 14, weight: .medium))
                
        }
        
    }
}

struct PremiumBoxView: View {
    var text: String
    var price: Binding<String>
    
    var body: some View {
        VStack {
            Text(text)
                .modifier(TextModifier(color: Asset.Colors., size: <#T##CGFloat#>, weight: <#T##Font.Weight#>))
        }
    }
}
