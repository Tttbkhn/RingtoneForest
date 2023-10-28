//
//  Constant.swift
//  RingtoneForest
//
//  Created by Thu Truong on 6/22/23.
//

import Foundation
import SwiftUI

enum Constant {
    static let blueGradient = [Color(asset: Asset.Colors.colorBlueGrad1273437), Color(asset: Asset.Colors.colorTabBG202329)]
    static let pinkGradient = [Color(asset: Asset.Colors.colorPinkGrad136242B), Color(asset: Asset.Colors.colorTabBG202329)]
    static let yellowGradient = [Color(asset: Asset.Colors.colorYellowGrad1312E25), Color(asset: Asset.Colors.colorTabBG202329)]
    static let greenGradient = [Color(asset: Asset.Colors.colorGreenGrad12C3727), Color(asset: Asset.Colors.colorTabBG202329)]
    static let tutorials = [Tutorial(id: 0, text: L10n.howToInstall, image: Asset.Assets.imgGarageBand), Tutorial(id: 1, text: L10n.step1, image: Asset.Assets.imgTutorial1), Tutorial(id: 2, text: L10n.step2, image: Asset.Assets.imgTutorial2), Tutorial(id: 3, text: L10n.step3, image: Asset.Assets.imgTutorial3), Tutorial(id: 4, text: L10n.step4, image: Asset.Assets.imgTutorial4), Tutorial(id: 5, text: L10n.step5, image: Asset.Assets.imgTutorial5), Tutorial(id: 6, text: L10n.step6, image: Asset.Assets.imgTutorial6)]
    static let isPurchased = "isPurchased"
    
    static let packages = [Package(productID: "com.tonemakerwallpaper.week", name: "One Week", date: 7), Package(productID: "com.tonemakerwallpaper.month", name: "One Month", date: 30), Package(productID: "com.tonemakerwallpaper.year", name: "One Year", date: 365)]
    
    static let appID = "6470258724"
    static let kTokenCache = "kTokenCache"
}
