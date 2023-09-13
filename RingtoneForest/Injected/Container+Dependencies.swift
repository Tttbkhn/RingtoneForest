//
//  Container+Dependencies.swift
//  RingtoneForest
//
//  Created by Thu Truong on 9/13/23.
//

import Foundation
import Swinject
import SwinjectAutoregistration

extension Container {
    func registerDependencies() {
        registerServices()
        registerViewModels()
    }

    func registerServices() {
        autoregister(TokenLDS.self, initializer: TokenLDS.init)
        autoregister(WallpaperRDS.self) { WallpaperRDS() }.inObjectScope(.container)
    }
    
    func registerViewModels() {
        autoregister(WallpaperViewModel.self, initializer: WallpaperViewModel.init)
    }
}


