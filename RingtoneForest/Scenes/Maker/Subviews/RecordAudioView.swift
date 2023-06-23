//
//  RecordAudioView.swift
//  RingtoneForest
//
//  Created by Thu Truong on 6/23/23.
//

import SwiftUI

struct RecordAudioView: View {
    var body: some View {
        ZStack {
            Image(asset: Asset.Assets.imgBackground)
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                ZStack {
                    HStack {
                        Image(asset: Asset.Assets.icClose)
                            .padding(.leading, 16)
                        
                        Spacer()
                    }
                    
                    
                    Text(L10n.media)
                        .modifier(TextModifier(color: Asset.Colors.colorWhite90, size: 20, weight: .bold))
                }
                .frame(height: 55)
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
        }

    }
}

struct RecordAudioView_Previews: PreviewProvider {
    static var previews: some View {
        RecordAudioView()
    }
}
