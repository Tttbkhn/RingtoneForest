//
//  RingtoneForestApp.swift
//  RingtoneForest
//
//  Created by Thu Trương on 13/06/2023.
//

import SwiftUI
import AVKit

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
    
//    static let container = Container()
    
    lazy var toneCoreDataStack: CoreDataStack = .init(modelName: "Tone")
    lazy var wallpaperCoreDataStack: CoreDataStack = .init(modelName: "Wallpaper")
    lazy var productCoreDataStack: CoreDataStack = .init(modelName: "ProductStore")
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        AppDelegate.instance = self
        
        try? AVAudioSession.sharedInstance().setCategory(.playback)
        
        return true
    }
}
