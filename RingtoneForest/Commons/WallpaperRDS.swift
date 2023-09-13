//
//  WallpaperRDS.swift
//  RingtoneForest
//
//  Created by Thu Truong on 9/13/23.
//

import Foundation
import Combine

enum WallpaperAPI {
    case getCategoryWallpaper
    case getToken
}

extension WallpaperAPI: APICall {
    var baseURL: String {
        return "http://164.90.157.54/"
    }
    
    var path: String {
        switch self {
        case .getToken:
            return "api/client/get-token/phamtienmanh0585@gmail.com"
        case .getCategoryWallpaper:
            return "api/client/get-category-wallpaper-live"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getToken, .getCategoryWallpaper:
            return .get
        }
    }
    
    var headers: [String : String] {
        let tokenLDS = TokenLDS()
        let accessToken = tokenLDS.get(key: Constant.kTokenCache)
        
        return ["Content-Type": "application/json", "Authorization": accessToken == "" ? "" : accessToken]
    }
    
    func body() throws -> Data? {
        return nil
    }
}

protocol WallpaperWebRepository: WebRepository {
    func getToken() -> AnyPublisher<WallpaperToken?, Error>
    func getCategoryWallpaper() -> AnyPublisher<WallpaperCategories?, Error>
}

class WallpaperRDS: ObservableObject, WallpaperWebRepository {
    var session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func getToken() -> AnyPublisher<WallpaperToken?, Error> {
        return call(endpoint: WallpaperAPI.getToken)
    }
    
    func getCategoryWallpaper() -> AnyPublisher<WallpaperCategories?, Error> {
        return call(endpoint: WallpaperAPI.getCategoryWallpaper)
    }
}
