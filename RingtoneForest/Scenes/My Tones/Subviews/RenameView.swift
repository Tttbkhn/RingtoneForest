//
//  RenameView.swift
//  RingtoneForest
//
//  Created by Thu Trương on 23/07/2023.
//

import SwiftUI

struct RenameView: View {
    var onCancel: () -> ()
    var onSubmit: (String) -> ()
    
    @State var renameString = ""
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Text(L10n.rename)
                    .modifier(TextModifier(color: Asset.Colors.colorBlack, size: 17, weight: .semibold))
                    .padding(.bottom, 2)
                    .padding(.top, 20)
                
                Text(L10n.renameNew)
                    .modifier(TextModifier(color: Asset.Colors.colorBlack, size: 13, weight: .regular))
                    .padding(.bottom, 16)
                
                Spacer()
                
                Color(asset: Asset.Colors.colorDivider3C3C4336)
                    .frame(height: 0.55)
                
                HStack(spacing: 0) {
                    Button {
                        onCancel()
                    } label: {
                        Text(L10n.cancel)
                            .modifier(TextModifier(color: Asset.Colors.colorBlue007AFF, size: 16, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                    }
                    
                    Color(asset: Asset.Colors.colorDivider3C3C4336)
                        .frame(width: 0.55)
                    
                    Button {
                        onSubmit(renameString)
                    } label: {
                        Text(L10n.ok)
                            .modifier(TextModifier(color: Asset.Colors.colorBlue007AFF, size: 16, weight: .regular))
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                    }
                }
                .frame(height: 48)
            }
            .frame(width: 300, height: 185)
            .background(Color(asset: Asset.Colors.colorGrayF2F2F2F80))
            .cornerRadius(19)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.3).ignoresSafeArea())
    }
}

struct RenameView_Previews: PreviewProvider {
    static var previews: some View {
        RenameView {
            
        } onSubmit: { _ in
            
        }

    }
}
