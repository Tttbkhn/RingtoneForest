//
//  WallpaperView.swift
//  RingtoneForest
//
//  Created by Thu Truong on 6/21/23.
//

import SwiftUI
import NukeUI

enum WallpaperType: Int {
    case live, staticPic
}

struct WallpaperView: View {
    @StateObject var viewModel: WallpaperViewModel
    
    @State var showLoading = false
    
    @State var goToWallpaper = false
    @State var selectedWallpaper: Wallpaper? = nil
    
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
                
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 18) {
                            ForEach(viewModel.wallpaperCategories) { category in
                                WallpaperRowView(title: category.name, wallpapers: category.wallpaper) { wallpaper in
                                    selectedWallpaper = wallpaper
                                    goToWallpaper = true
                                }
                            }
                        }
                    }
                
                Spacer()
                    .frame(height: 60)
            }
            .padding(.horizontal, 16)
            
            if viewModel.showLoading {
                LoadingView()
            }
            
            if let selectedWallpaper = selectedWallpaper, goToWallpaper {
                NavigationLink(destination: WallpaperDetailView(wallpaper: selectedWallpaper), isActive: $goToWallpaper) {
                    EmptyView()
                }
            }
        }
        .onAppear() {
            viewModel.getWallpapers()
        }
    }
}

struct WallpaperView_Previews: PreviewProvider {
    static var previews: some View {
        let wallpaperVM = AppDelegate.container.resolve(WallpaperViewModel.self)!
        
        WallpaperView(viewModel: wallpaperVM)
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
    var title: String
    var wallpapers: [Wallpaper]
    
    var onTap: (Wallpaper) -> ()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(title)
                .modifier(TextModifier(color: Asset.Colors.colorWhite, size: 16, weight: .regular))
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(wallpapers) { wallpaper in
                        LazyImage(url: URL(string: wallpaper.thumbnail)) { state in
                            if let image = state.image {
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 120, height: 228)
                            }
                        }
                        .frame(width: 120, height: 228)
                        .cornerRadius(15)
                        .overlay(Image(asset: Asset.Assets.icLivePic)
                            .offset(x: -10, y: 10)
                                 , alignment: .topTrailing)
                        .onTapGesture {
                            onTap(wallpaper)
                        }
                    }
                }
            }
        }
    }
}

struct WallpaperRowView_Previews: PreviewProvider {
    static var previews: some View {
        WallpaperRowView(title: "About", wallpapers: []) { _ in}
    }
}
