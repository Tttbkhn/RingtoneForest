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
    let id: Int
    var image: UIImage?
    let video: PHAsset
    let duration: String
}

struct ImagesAsset: Identifiable {
    let id = UUID()
    let image: UIImage
}
