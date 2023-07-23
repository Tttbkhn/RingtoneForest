//
//  WallpaperDetailView.swift
//  RingtoneForest
//
//  Created by Thu Trương on 23/07/2023.
//

import SwiftUI

struct WallpaperDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var isPreview = false
    
    var body: some View {
        ZStack {
            Image(asset: Asset.Assets.imgBackground)
                .resizable()
                .ignoresSafeArea()
                .onTapGesture {
                    isPreview = false
                }
            
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
                .padding(.horizontal, 16)
                .padding(.top, 23)
                .padding(.bottom, 15)
                
                if isPreview {
                    VStack {
                        Text("Wednesday 7 September")
                            .modifier(TextModifier(color: Asset.Colors.colorWhite70, size: 20, weight: .bold))
                        
                        Text("12:57")
                            .modifier(TextModifier(color: Asset.Colors.colorWhite70, size: 92, weight: .bold))
                    }
                    
                }
                
                Spacer()
                
                ZStack {
                    Button {
                        
                    } label: {
                        Image(asset: Asset.Assets.icDownload)
                            .contentShape(Rectangle())
                    }
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            isPreview = true
                        } label: {
                            Image(asset: Asset.Assets.icPreview)
                                .padding(.trailing, 63)
                                .contentShape(Rectangle())
                        }

                        
                    }
                }
            }
        }
    }
}

struct WallpaperDetailView_Previews: PreviewProvider {
    static var previews: some View {
        WallpaperDetailView()
    }
}
