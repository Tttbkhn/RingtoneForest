//
//  MakerView.swift
//  RingtoneForest
//
//  Created by Thu Truong on 6/21/23.
//

import SwiftUI

struct MakerView: View {
    @State var goToVideoPicker = false
    
    var body: some View {
        ZStack {
            Image(asset: Asset.Assets.imgBackground)
                .resizable()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack(spacing: 10) {
                    Image(asset: Asset.Assets.icTunes)
                    
                    Text(L10n.appName)
                        .modifier(TextModifier(color: Asset.Colors.colorGreen69BE15, size: 30, weight: .bold))
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Image(asset: Asset.Assets.icCrown)
                            .background(
                                Color(asset: Asset.Colors.colorTabBG202329)
                                    .blur(radius: 30)
                                    .brightness(0.7)
                                .frame(width: 36, height: 36)
                                .cornerRadius(11)
                            )
                    }

                    
                }
                .padding(.top, 28)
                .padding(.bottom, 82)
                
                HStack(spacing: 14) {
                    Button {
                        goToVideoPicker = true
                    } label: {
                        MakerGridView(icon: Asset.Assets.icVideo, text: L10n.fromVideo, colors: Constant.blueGradient)
                    }
                    
                    Button {
                        
                    } label: {
                        MakerGridView(icon: Asset.Assets.icRecord, text: L10n.recordAudio, colors: Constant.pinkGradient)
                    }

                }
                .padding(.bottom, 14)
                
                HStack(spacing: 14) {
                    Button {
                        
                    } label: {
                        MakerGridView(icon: Asset.Assets.icLiveWallpaper, text: L10n.liveWallpaperMaker, colors: Constant.yellowGradient)
                    }
                    
                    Button {
                        
                    } label: {
                        MakerGridView(icon: Asset.Assets.icImportFile, text: L10n.importFiles, colors: Constant.greenGradient)
                    }

                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
        }
//        .fullScreenCover(item: <#T##Binding<Identifiable?>#>, content: <#T##(Identifiable) -> View#>)
    }
}

struct MakerView_Previews: PreviewProvider {
    static var previews: some View {
        MakerView()
    }
}

struct MakerGridView: View {
    var icon: ImageAsset
    var text: String
    var colors: [Color]
    
    var body: some View {
        VStack(spacing: 48) {
            Image(asset: icon)
            Text(text)
                .modifier(TextModifier(color: Asset.Colors.colorWhite70, size: 14, weight: .medium))
        }
        .modifier(MakerGridModifier(colors: colors))
    }
}

struct MakerGridView_Previews: PreviewProvider {
    static var previews: some View {
        MakerGridView(icon: Asset.Assets.icVideo, text: L10n.fromVideo, colors: Constant.blueGradient)
    }
}

struct MakerGridModifier: ViewModifier {
    var colors: [Color]
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .frame(height: 184)
            .background(LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.white.opacity(0.3),
                            lineWidth: 0.5)
                    .shadow(color: Color.white.opacity(0.3),
                            radius: 3)
                
            )
    }
}
