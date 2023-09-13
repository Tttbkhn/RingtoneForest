//
//  WallpaperCategories.swift
//  RingtoneForest
//
//  Created by Thu Truong on 9/13/23.
//

import Foundation

struct WallpaperCategories: Codable {
    let statusCode: Int
    let data: [WallpaperCategory]
}

struct WallpaperCategory: Codable, Identifiable {
    let id: Int
    let name: String
    let type: String
    let wallpaper: [Wallpaper]
}

struct Wallpaper: Codable, Identifiable, Equatable {
    static func == (lhs: Wallpaper, rhs: Wallpaper) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: Int
    let filename: String
    let thumbnail: String
    let premium: Bool?
    let categoryId: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, filename, thumbnail, premium
        case categoryId = "category_id"
    }
}
