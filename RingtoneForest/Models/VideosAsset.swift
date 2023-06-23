//
//  VideosAsset.swift
//  RingtoneForest
//
//  Created by Thu Truong on 6/23/23.
//

import Foundation
import Photos
import UIKit

struct VideosAsset: Identifiable {
    let id = UUID()
    let image: UIImage?
    let video: PHAsset
}

struct ImagesAsset: Identifiable {
    let id = UUID()
    let image: UIImage
}
