//
//  LiveWallpaperCutterView.swift
//  RingtoneForest
//
//  Created by Thu Trương on 25/06/2023.
//

import SwiftUI

struct LiveWallpaperCutterView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var isDoneEditing = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack {
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(asset: Asset.Assets.icBack)
                            .contentShape(Rectangle())
                    }

                    Spacer()
                    
                    if !isDoneEditing {
                        FillButtonView(text: L10n.next, width: 73, height: 36, cornerRadius: 11, textSize: 15, textColor: Asset.Colors.colorBlack, foregroundColor: Asset.Colors.colorWhite) {
                            isDoneEditing = true
                        }
                    }
                }
                
                Spacer()
                
                if !isDoneEditing {
                    ZStack {
                        Color.white
                    }
                    .frame(height: 47)
                    .padding(.bottom, 38)
                } else {
                    FillButtonView(text: L10n.save, width: UIScreen.main.bounds.width - 32, height: 54, cornerRadius: 15, textSize: 16, textColor: Asset.Colors.colorWhite, foregroundColor: Asset.Colors.colorGreen69BE15) {
                        
                    }
                    .padding(.bottom, 38)
                }
               
            }
            .padding(.horizontal, 16)
        }
    }
}

struct LiveWallpaperCutterView_Previews: PreviewProvider {
    static var previews: some View {
        LiveWallpaperCutterView()
    }
}
