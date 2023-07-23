//
//  WallpaperView.swift
//  RingtoneForest
//
//  Created by Thu Truong on 6/21/23.
//

import SwiftUI

enum WallpaperType: Int {
    case live, staticPic
}

struct WallpaperView: View {
    @State var selected: WallpaperType = .live
    
    var body: some View {
        let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
        
        ZStack {
            Image(asset: Asset.Assets.imgBackground)
                .resizable()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text(L10n.wallpaper)
                        .modifier(TextModifier(color: Asset.Colors.colorGreen69BE15, size: 30, weight: .bold))
                    
                    Spacer()
                }
                .padding(.top, 28)
                .padding(.bottom, 27)
                
                HStack {
                    WallpaperButtonView(isSelected: $selected, text: L10n.live, type: .live)
                    
                    WallpaperButtonView(isSelected: $selected, text: L10n.static, type: .staticPic)
                    
                    Spacer()
                }
                .padding(.bottom, 18)
                
                if selected == .live {
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 18) {
                            WallpaperRowView()
                            WallpaperRowView()
                        }
                    }
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns) {
                            WallpaperRowView()
                        }
                    }
                }
                
            }
            .padding(.horizontal, 16)

        }
    }
}

struct WallpaperView_Previews: PreviewProvider {
    static var previews: some View {
        WallpaperView()
    }
}

struct WallpaperButtonView: View {
    @Binding var isSelected: WallpaperType
    var text: String
    var type: WallpaperType
    
    var body: some View {
        Button {
            isSelected = type
        } label: {
            Text(text)
                .modifier(TextModifier(color: isSelected == type ? Asset.Colors.colorGreen69BE15 : Asset.Colors.colorGray83868A, size: 14, weight: .medium))
                .frame(width: 100, height: 40)
        }
        .background(Color(asset: isSelected == type ? Asset.Colors.colorGreen69BE15O15 : Asset.Colors.colorGray83868A15))
        .cornerRadius(15)

    }
}

struct WallpaperRowView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(L10n.about)
                .modifier(TextModifier(color: Asset.Colors.colorWhite, size: 16, weight: .regular))
            
            ScrollView {
                LazyHStack {
                    Image(asset: Asset.Assets.imgTutorial1)
                        .resizable()
                        .frame(width: 120, height: 228)
                        .cornerRadius(15)
                        .overlay(Image(asset: Asset.Assets.icCrown)
                            .offset(x: -10, y: 10)
                                 , alignment: .topTrailing)
                }
            }
        }
    }
}

struct WallpaperRowView_Previews: PreviewProvider {
    static var previews: some View {
        WallpaperRowView()
    }
}
