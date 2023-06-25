//
//  SavingView.swift
//  RingtoneForest
//
//  Created by Thu Trương on 25/06/2023.
//

import SwiftUI

struct SavingView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.4).ignoresSafeArea()
            
            ZStack {
                Color.white
                    .blur(radius: 60)
                
                Image(asset: Asset.Assets.icDone)
            }
            .frame(width: 148, height: 139)
            .cornerRadius(19)
        }
    }
}

struct SavingView_Previews: PreviewProvider {
    static var previews: some View {
        SavingView()
    }
}
