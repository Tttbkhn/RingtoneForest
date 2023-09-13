//
//  PHAssetExt.swift
//  RingtoneForest
//
//  Created by Thu Truong on 9/13/23.
//

import Foundation
import Photos
import UIKit

extension PHAsset {
    func getVideoFrames(completion: @escaping ([UIImage]?, AVAsset?) -> Void) {
        guard self.mediaType == .video else { completion(nil, nil); return }
        
        let manager = PHCachingImageManager()
        let options = PHVideoRequestOptions()
        options.isNetworkAccessAllowed = true
        
        manager.requestAVAsset(forVideo: self, options: options) { asset, audioMix, info in
            guard let asset = asset else { completion(nil, nil); return }
            let imgGenerator: AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            imgGenerator.requestedTimeToleranceBefore = CMTimeMake(value: 1, timescale: 15)
            imgGenerator.requestedTimeToleranceAfter = CMTimeMake(value: 1, timescale: 15)
            let duration: Float64 = CMTimeGetSeconds(asset.duration)
            var frames = [UIImage]()
            for index: Int in stride(from: 0, through: Int(duration), by: Int(duration / 10) + 1) {
                let time: CMTime = CMTimeMakeWithSeconds(Float64(index), preferredTimescale: 600)
                let cgImage: CGImage
                do {
                    try cgImage = imgGenerator.copyCGImage(at: time, actualTime: nil)
                    frames.append(UIImage(cgImage: cgImage))
                } catch {
                    print("Error generating image: \(error)")
                }
            }
            
            completion(frames, asset)
        }
    }
}
