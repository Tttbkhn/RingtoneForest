//
//  WallpaperVideoPlayer.swift
//  RingtoneForest
//
//  Created by Thu Truong on 9/13/23.
//

import Foundation
import SwiftUI
import AVKit

struct WallpaperVideoPlayer: UIViewControllerRepresentable {
    var avPlayer: AVPlayer? = nil
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = CustomWallpaperVideoPlayer()
        controller.videoGravity = .resizeAspectFill
        controller.showsPlaybackControls = false
        controller.allowsPictureInPicturePlayback = false
        return controller
    }
    
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        uiViewController.player = avPlayer
    }
}

class CustomWallpaperVideoPlayer: AVPlayerViewController {
    override var prefersStatusBarHidden: Bool {
        return false
    }
}
