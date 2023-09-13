//
//  AVPlayerItemExt.swift
//  RingtoneForest
//
//  Created by Thu Truong on 9/13/23.
//

import Foundation
import AVKit

extension AVPlayerItem {
    var url: URL? {
        return (asset as? AVURLAsset)?.url
    }
}
