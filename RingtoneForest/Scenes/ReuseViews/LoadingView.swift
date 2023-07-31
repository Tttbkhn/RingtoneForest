//
//  LoadingView.swift
//  RingtoneForest
//
//  Created by Thu Truong on 7/31/23.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            ProgressView()
                .accentColor(.white)
                .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
