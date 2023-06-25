//
//  AudioFromVideoView.swift
//  RingtoneForest
//
//  Created by Thu Truong on 6/23/23.
//

import SwiftUI
import Photos

enum MediaKind: Int {
    case audioFromVideo, wallpaperMaker
}

struct VideoView: View {
    var type: MediaKind
    @State var videos: [VideosAsset] = []
    @State var selectedAsset: VideosAsset? = nil
    
    var body: some View {
        let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
        
        VStack {
            ZStack {
                HStack {
                    Image(asset: Asset.Assets.icClose)
                        .padding(.leading, 16)
                    
                    Spacer()
                }
                
                
                Text(L10n.media)
                    .modifier(TextModifier(color: Asset.Colors.colorWhite90, size: 20, weight: .bold))
            }
            .frame(height: 55)
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 0) {
                    
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color(asset: Asset.Colors.colorBG16181C).ignoresSafeArea())
    }
    
    func fetchVideos() {
        let semaphore = DispatchSemaphore(value: 1)
        
        let fetchResults = PHAsset.fetchAssets(with: PHAssetMediaType.video, options: nil)
        var videos: [VideosAsset] = []
        
        fetchResults.enumerateObjects { object, count, stop in
            PHCachingImageManager.default().requestImage(for: object, targetSize: CGSize(width: UIScreen.main.bounds.width / 4, height: UIScreen.main.bounds.width / 4), contentMode: .aspectFill, options: nil) { photo, info in
                let isDegraded = (info?[PHImageResultIsDegradedKey] as? Bool) ?? false
                if isDegraded {
                    return
                }
                
                let videoAsset = VideosAsset(image: photo, video: object)
                semaphore.wait()
                videos.append(videoAsset)
                semaphore.signal()
                
                if videos.count == fetchResults.count {
                    self.videos = videos.sorted { asset1, asset2 in
                        if let createDate1 = asset1.video.creationDate, let createDate2 = asset2.video.creationDate {
                            return createDate1 > createDate2
                        }
                        
                        return false
                    }
                }
            }
        }
    }
}

struct VideoView_Previews: PreviewProvider {
    static var previews: some View {
        VideoView(type: .audioFromVideo)
    }
}

struct VideoGridView: View {
    var image: String
    var time: String
    var body: some View {
        ZStack {
            Image(asset: Asset.Assets.icImportFile)
            
            VStack {
                Spacer()
                
                HStack {
                    Image(asset: Asset.Assets.icVideoFromMedia)
                        .padding(.leading, 5)
                    
                    Spacer()
                    
                    Text(time)
                        .modifier(TextModifier(color: Asset.Colors.colorWhite, size: 12, weight: .regular))
                        .padding(.trailing, 8)
                }
                .frame(height: 26)
            }
        }
        .frame(width: UIScreen.main.bounds.width / 4, height: UIScreen.main.bounds.width / 4)
    }
}

struct VideoGridView_Previews: PreviewProvider {
    static var previews: some View {
        VideoGridView(image: "Asd", time: "00:35")
    }
}
