//
//  VLCPlayerView.swift
//  RingtoneForest
//
//  Created by Thu Truong on 9/13/23.
//

import Foundation
import SwiftUI
import MobileVLCKit
import UIKit

struct VLCPlayerView: UIViewRepresentable {
    var url: URL
    
    func makeUIView(context: Context) -> PlayerUIView {
        return PlayerUIView(url: url)
    }
    
    func updateUIView(_ uiView: PlayerUIView, context: Context) {
        print("update")
        uiView.redrawNewURL(url: url)
    }
}

class PlayerUIView: UIView, VLCMediaPlayerDelegate {
    private let mediaPlayer = VLCMediaPlayer()
    
    init(url: URL) {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        
        mediaPlayer.media = VLCMedia(url: url)
        mediaPlayer.delegate = self
        mediaPlayer.scaleFactor = 1.978
        let cs = ("FILL_TO_SCREEN" as NSString).utf8String
        let buffer = UnsafeMutablePointer<Int8>(mutating: cs)
        self.mediaPlayer.videoCropGeometry = nil
        self.mediaPlayer.videoAspectRatio = buffer
    }
    
    func redrawNewURL(url: URL) {
        mediaPlayer.media = VLCMedia(url: url)
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        print("redraw")
        mediaPlayer.scaleFactor = 1.978
        self.mediaPlayer.videoCropGeometry = nil
        let cs = ("FILL_TO_SCREEN" as NSString).utf8String
        let buffer = UnsafeMutablePointer<Int8>(mutating: cs)
        self.mediaPlayer.videoAspectRatio = buffer
        mediaPlayer.drawable = self
        mediaPlayer.play()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
