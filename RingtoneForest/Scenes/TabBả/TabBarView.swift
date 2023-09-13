//
//  TabBarView.swift
//  RingtoneForest
//
//  Created by Thu Trương on 13/06/2023.
//

import SwiftUI

enum Tab: String {
    case maker = "Maker"
    case myTone = "My tone"
    case wallpaper = "Wallpaper"
    case settings = "Setting"
}

struct TabBarView: View {
    @State var selectedTab = Tab.maker
    @Environment(\.safeAreaInsets) var safeAreaInsets
    
    var body: some View {
        ZStack {
            switch selectedTab {
            case .maker:
                NavigationView {
                    ZStack {
                        MakerView()
                        
                        VStack {
                            Spacer()
                            
                            tabBarView
                        }
                    }
                }
                .navigationViewStyle(StackNavigationViewStyle())
            case .myTone:
                NavigationView {
                    ZStack {
                        MyTonesView()
                        
                        VStack {
                            Spacer()
                            
                            tabBarView
                        }
                    }
                    .ignoresSafeArea(.keyboard, edges: .bottom)
                }
                .navigationViewStyle(StackNavigationViewStyle())
            case .wallpaper:
                NavigationView {
                    ZStack {
                        let wallpaperVM = AppDelegate.container.resolve(WallpaperViewModel.self)!
                        
                        WallpaperView(viewModel: wallpaperVM)
                        
                        VStack {
                            Spacer()
                            
                            tabBarView
                        }
                    }
                }
                .navigationViewStyle(StackNavigationViewStyle())
            case .settings:
                NavigationView {
                    ZStack {
                        SettingsView()
                        
                        VStack {
                            Spacer()
                            
                            tabBarView
                        }
                    }
                }
                .navigationViewStyle(StackNavigationViewStyle())
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.goToMyTone)) { data in
            if let data = data.object as? NSDictionary {
                if let fromHome = data["fromMake"] as? Bool {
                    if fromHome {
                        selectedTab = .myTone
                    }
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.goToMaker)) { _ in
            selectedTab = .maker
        }
    }
    
    var tabBarView: some View {
        HStack {
            tabBarItem(.maker, icon: Asset.Assets.icMakerUnselected, selectedIcon: Asset.Assets.icMakerSelected)
            tabBarItem(.myTone, icon: Asset.Assets.icMytonesUnselected, selectedIcon: Asset.Assets.icMytonesSelected)
            tabBarItem(.wallpaper, icon: Asset.Assets.icWallpaperUnselected, selectedIcon: Asset.Assets.icWallpaperSelected)
            tabBarItem(.settings, icon: Asset.Assets.icSettingUnselected, selectedIcon: Asset.Assets.icSettingSelected)
        }
        .padding(.top, 11)
        .frame(maxWidth: .infinity)
        .frame(height: 60)
        .background(Color(asset: Asset.Colors.colorBG).ignoresSafeArea())
    }
    
    func tabBarItem(_ tab: Tab, icon: ImageAsset, selectedIcon: ImageAsset) -> some View {
        VStack(spacing: 4) {
            Image(asset: selectedTab == tab ? selectedIcon : icon)
            
            Text(tab.rawValue)
                .foregroundColor(Color(asset: selectedTab == tab ? Asset.Colors.colorGreen69BE15 : Asset.Colors.colorGray83868A))
                .font(.system(size: 12, weight: .medium))
            
            if selectedTab == tab {
                Rectangle()
                    .frame(height: 5)
                    .foregroundColor(Color(asset: Asset.Colors.colorGreen69BE15))
                    .blur(radius: 15)
            } else {
                Spacer()
                    .frame(height: 5)
            }
            
            Spacer()
            
        }
        .frame(width: (UIScreen.main.bounds.width - 50) / 4, height: 60)
        .contentShape(Rectangle())
        .onTapGesture {
            selectedTab = tab
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
