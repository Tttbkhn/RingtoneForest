//
//  RingtoneForestApp.swift
//  RingtoneForest
//
//  Created by Thu Trương on 13/06/2023.
//

import SwiftUI
import AVKit
import Swinject
import Tiercel
import SwiftyStoreKit

@main
struct RingtoneForestApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            TabBarView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    static private(set) var instance: AppDelegate! = nil
    
    static let container = Container()
    
    lazy var toneCoreDataStack: CoreDataStack = .init(modelName: "Tone")
    lazy var wallpaperCoreDataStack: CoreDataStack = .init(modelName: "Wallpaper")
    lazy var productCoreDataStack: CoreDataStack = .init(modelName: "ProductStore")
    
    var sessionManager: SessionManager = {
        var configuration = SessionConfiguration()
        configuration.allowsCellularAccess = true
        let manager = SessionManager("Ringtones", configuration: configuration)
        return manager
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        AppDelegate.container.registerDependencies()
        AppDelegate.instance = self
        
        setupStoreKit()
        checkPurchased()
        
        try? AVAudioSession.sharedInstance().setCategory(.playback)
        
        return true
    }
    
    func setupStoreKit() {
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                case .failed, .purchasing, .deferred:
                    break
                @unknown default:
                    fatalError()
                }
            }
        }
    }
    
    func checkPurchased() {
        let productPurchased = ProductStoreCacheCD.shared.getPurchased()
        if let productPurchased = productPurchased {
            if productPurchased.dateExpired! <= Calendar.current.dateComponents(in: .current, from: Date()).date! {
                UserDefaults.standard.setValue(false, forKey: Constant.isPurchased)
                ProductStoreCacheCD.shared.removeProductExpired()
            } else {
                UserDefaults.standard.setValue(true, forKey: Constant.isPurchased)
            }
        } else {
            UserDefaults.standard.setValue(false, forKey: Constant.isPurchased)
        }
    }
}
