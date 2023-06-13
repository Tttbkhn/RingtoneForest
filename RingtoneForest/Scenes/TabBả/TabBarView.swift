//
//  TabBarView.swift
//  RingtoneForest
//
//  Created by Thu Trương on 13/06/2023.
//

import SwiftUI

enum Tab: Int {
    case maker, myTone, wallpaper, settings
}

struct TabBarView: View {
    @State var selectedTab = Tab.maker
    
    var body: some View {
        ZStack {
            switch selectedTab {
            case .maker:
                ZStack {
                
                }
            case .myTone:
                ZStack {
                    
                }
            case .wallpaper:
                ZStack {
                    
                }
            case .settings:
                ZStack {
                    
                }
            }
        }
    }
    
    var tabBarView: some View {
        ZStack {
            HStack {
                
            }
        }
    }
    
    func tabBarItem(_ tab: Tab, icon: ImageAsset, selectedIcon: ImageAsset) -> some View {
        
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
