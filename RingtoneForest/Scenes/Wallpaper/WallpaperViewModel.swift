//
//  WallpaperViewModel.swift
//  RingtoneForest
//
//  Created by Thu Truong on 9/13/23.
//

import Foundation
import Combine

class WallpaperViewModel: ObservableObject {
    private var bags = Set<AnyCancellable>()
    private let wallpaperRDS: WallpaperRDS
    
    @Published var wallpaperCategories: [WallpaperCategory] = []
    @Published var showLoading = false
    
    init(wallpaperRDS: WallpaperRDS) {
        self.wallpaperRDS = wallpaperRDS
    }
    
    func getWallpapers() {
        showLoading = true
        
        wallpaperRDS.getCategoryWallpaper().sinkToResult { [weak self] result in
            switch result {
            case .success(let res):
                if let res = res {
                    self?.wallpaperCategories = res.data
                    print(res.data)
                }
            case .failure(let error):
                print(error)
            }
            
            DispatchQueue.main.async {
                self?.showLoading = false
            }
        }.store(in: &bags)
    }
}
