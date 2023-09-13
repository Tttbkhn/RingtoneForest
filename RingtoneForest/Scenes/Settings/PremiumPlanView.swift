//
//  PremiumPlanView.swift
//  RingtoneForest
//
//  Created by Thu Trương on 26/06/2023.
//

import SwiftUI

struct PremiumPlanView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var priceWeek = ""
    @State var priceMonth = ""
    @State var priceYear = ""
    
    var body: some View {
        ZStack {
            Image(asset: Asset.Assets.imgBackground)
                .resizable()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(asset: Asset.Assets.icClose)
                            .contentShape(Rectangle())
                    }
                    
                    Spacer()
                }
                .padding(.top, 10)
                .padding(.bottom, 10)
                
                HStack(spacing: 18) {
                    Text(L10n.ringtonesPro)
                        .modifier(TextModifier(color: Asset.Colors.colorGreen69BE15, size: 35, weight: .bold))
                    
                    Image(asset: Asset.Assets.imgPro)
                }
                .padding(.bottom, 54)
                
                VStack(alignment: .leading, spacing: 15) {
                    PremiumTextRowView(text: L10n.unlimited1)
                    PremiumTextRowView(text: L10n.unlimited2)
                    PremiumTextRowView(text: L10n.unlimited3)
                    PremiumTextRowView(text: L10n.removeAds)
                }
                
                Spacer()
                
                HStack {
                    PremiumBoxView(text: L10n.oneWeek, priceText: "$ 2.9")
                    PremiumBoxView(text: L10n.oneMonth, priceText: "$ 9.9")
                    PremiumBoxView(text: L10n.oneYear, priceText: "$ 49.9")
                }
                .padding(.bottom, 40)
                
                HStack(spacing: 0) {
                    Text(L10n.trial)
                        .modifier(TextModifier(color: Asset.Colors.colorWhite50, size: 14, weight: .medium))
                }
                .padding(.bottom, 30)
                
                FillButtonView(text: L10n.try, width: UIScreen.main.bounds.width - 32, height: 60, cornerRadius: 18, textSize: 17, textColor: Asset.Colors.colorWhite, foregroundColor: Asset.Colors.colorGreen69BE15) {
                    
                }
                .padding(.bottom, 45)
                
                ZStack {
                    Button {
                        
                    } label: {
                        Text(L10n.restore)
                            .underline()
                            .modifier(TextModifier(color: Asset.Colors.colorWhite, size: 14, weight: .regular))
                            .contentShape(Rectangle())
                    }

                    
                    
                    HStack {
                        Button {
                            
                        } label: {
                            Text(L10n.privacyPolicy)
                                .underline()
                                .modifier(TextModifier(color: Asset.Colors.colorWhite, size: 14, weight: .regular))
                                .contentShape(Rectangle())
                        }
                        
                        Spacer()
                        
                        Button {
                            
                        } label: {
                            Text(L10n.terms)
                                .underline()
                                .modifier(TextModifier(color: Asset.Colors.colorWhite, size: 14, weight: .regular))
                                .contentShape(Rectangle())
                        }
                    }
                    .padding(.horizontal, 30)
                }
                
                Spacer()
                
                Text(L10n.warning)
                    .multilineTextAlignment(.center)
                    .modifier(TextModifier(color: Asset.Colors.colorWhite40, size: 10, weight: .regular))
                    .padding(.bottom, 20)
            }
            .padding(.horizontal, 16)
        }
        .navigationBarHidden(true)
    }
}

struct PremiumPlanView_Previews: PreviewProvider {
    static var previews: some View {
        PremiumPlanView()
    }
}

struct PremiumTextRowView: View {
    var text: String
    var body: some View {
        HStack {
            Image(asset: Asset.Assets.icSmallCrown)
            
            Text(text)
                .modifier(TextModifier(color: Asset.Colors.colorGrayBCBCBC, size: 14, weight: .medium))
        }
    }
}

struct PremiumTextRowView_Previews: PreviewProvider {
    static var previews: some View {
        PremiumTextRowView(text: L10n.unlimited1)
    }
}

struct PremiumBoxView: View {
    @State var isSelected = false
    var text: String
    var priceText: String
    
    var body: some View {
        VStack(spacing: 13) {
            Text(text)
                .modifier(TextModifier(color: isSelected ? Asset.Colors.colorGreen69BE15 : Asset.Colors.colorGrayC2C2C2, size: 11, weight: .regular))
            
            Text(priceText)
                .modifier(TextModifier(color: isSelected ? Asset.Colors.colorGreen69BE15 : Asset.Colors.colorGrayC2C2C2, size: 18, weight: .bold))
        }
        .frame(maxWidth: .infinity)
        .frame(height: 80)
        .background(RoundedRectangle(cornerRadius: 17)
            .stroke(Color(asset: Asset.Colors.colorGreen69BE15), lineWidth: isSelected ? 2 : 0)
            .background(Color(asset: isSelected ? Asset.Colors.colorGreen69BE15 : Asset.Colors.colorGray83868A).opacity(0.25)))
        .cornerRadius(17)
    }
}

struct PremiumBoxView_Previews: PreviewProvider {
    static var previews: some View {
        PremiumBoxView(text: L10n.oneWeek, priceText: "$ 2.9")
    }
}
