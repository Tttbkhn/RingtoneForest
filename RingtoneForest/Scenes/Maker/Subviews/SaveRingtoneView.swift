//
//  SaveRingtoneView.swift
//  RingtoneForest
//
//  Created by Thu Trương on 25/06/2023.
//

import SwiftUI

struct SaveRingtoneView: View {
    @State var name = ""
    var onCancel: () -> ()
    var onOk: (String) -> ()
    var body: some View {
        ZStack {
            Color(asset: Asset.Colors.colorBlack).opacity(0.3).ignoresSafeArea()
            
            VStack(spacing: 0) {
                Text(L10n.saveRingtone)
                    .modifier(TextModifier(color: Asset.Colors.colorBlack, size: 17, weight: .bold))
                    .padding(.top, 19)
                    .padding(.bottom, 2)
                
                Text(L10n.enterRingtone)
                    .modifier(TextModifier(color: Asset.Colors.colorBlack, size: 13, weight: .regular))
                    
                Spacer()
                
                CompatTextField("Name", firstResponder: true, text: $name, returnKeyType: .done, size: 16, textPlaceholderColor: Asset.Colors.colorDivider3C3C4336, textColor: Asset.Colors.colorBlack)
                    .padding(.all, 4)
                    .background(Color.white.cornerRadius(5).background(RoundedRectangle(cornerRadius: 5).stroke(Color(asset: Asset.Colors.colorDivider3C3C4336))))
                    .padding(.horizontal, 18)
                    .frame(height: 34)
                    .padding(.bottom, 20)
                
                Divider()
                    .frame(height: 0.5)
                    .overlay(Color(asset: Asset.Colors.colorDivider707070))
                
                HStack(spacing: 0) {
                    Button {
                        onCancel()
                    } label: {
                        Text(L10n.cancel)
                            .modifier(TextModifier(color: Asset.Colors.colorBlue007AFF, size: 16, weight: .semibold))
                            .frame(maxWidth: .infinity)
                    }
                    
                    Divider()
                        .frame(width: 0.5)
                        .overlay(Color(asset: Asset.Colors.colorDivider707070))
                    
                    Button {
                        onOk(name)
                    } label: {
                        Text(L10n.ok)
                            .modifier(TextModifier(color: Asset.Colors.colorBlue007AFF, size: 16, weight: .regular))
                            .frame(maxWidth: .infinity)
                    }

                }
                .frame(height: 48)
            }
            .frame(width: UIScreen.main.bounds.width - 116, height: 183)
            .background(Color(asset: Asset.Colors.colorGrayF2F2F2))
            .cornerRadius(19)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
    }
}

struct SaveRingtoneView_Previews: PreviewProvider {
    static var previews: some View {
        SaveRingtoneView {
            
        } onOk: { _ in
            
        }

    }
}
