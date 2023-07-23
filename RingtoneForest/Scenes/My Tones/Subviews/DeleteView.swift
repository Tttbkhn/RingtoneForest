//
//  DeleteView.swift
//  RingtoneForest
//
//  Created by Thu Trương on 23/07/2023.
//

import SwiftUI

struct DeleteView: View {
    var onCancel: () -> ()
    var onDelete: () -> ()
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Text(L10n.delete)
                    .modifier(TextModifier(color: Asset.Colors.colorBlack, size: 17, weight: .semibold))
                    .padding(.bottom, 7)
                    .padding(.top, 20)
                
                Text(L10n.deleteRingtone)
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
                        onDelete()
                    } label: {
                        Text(L10n.ok)
                            .modifier(TextModifier(color: Asset.Colors.colorBlue007AFF, size: 16, weight: .regular))
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                    }
                }
                .frame(height: 48)
            }
            .frame(width: 270, height: 133)
            .background(Color(asset: Asset.Colors.colorGrayF8F8F8).opacity(0.92))
            .cornerRadius(14)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.3).ignoresSafeArea())

    }
}

struct DeleteView_Previews: PreviewProvider {
    static var previews: some View {
        DeleteView {
            
        } onDelete: {
            
        }

    }
}
