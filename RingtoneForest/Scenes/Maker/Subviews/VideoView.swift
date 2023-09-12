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
    @Environment(\.presentationMode) var presentationMode
    var type: MediaKind
    @State var videos: [VideosAsset] = []
    @State var selectedAsset: VideosAsset? = nil
    
    @State var selectedURL: URL? = nil
    @State var goToAudioCutter = false
    @State var showLoading = false
    
    @State var toast: Toast? = nil
    
    var body: some View {
        let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
        
        ZStack {
            VStack {
                ZStack {
                    HStack {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image(asset: Asset.Assets.icClose)
                                .padding(.leading, 16)
                        }

                        Spacer()
                    }


                    Text(L10n.media)
                        .modifier(TextModifier(color: Asset.Colors.colorWhite90, size: 20, weight: .bold))
                }
                .frame(height: 55)
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 0) {
                        ForEach(videos) { video in
                            VideoGridView(image: video.image ?? UIImage(), time: video.duration)
                                .onTapGesture {
                                    guard let url = video.url else { return }
                                    
                                    let composition = AVMutableComposition()
                                    do {
                                        let asset = url
                                        guard let audioAssetTrack = asset.tracks(withMediaType: .audio).first else { return }
                                        guard let audioCompositionTrack = composition.addMutableTrack(withMediaType: .audio
                                                                                                      , preferredTrackID: kCMPersistentTrackID_Invalid) else { return }
                                        try audioCompositionTrack.insertTimeRange(audioAssetTrack.timeRange, of: audioAssetTrack, at: .zero)
                                        
                                        let outputURL = URL(fileURLWithPath: NSTemporaryDirectory() + "tempForCuttingAudioFromVideo.m4a")
                                        RingtoneExtractor.shared.removeFileIfExists(fileURL: outputURL.path)
                                        
                                        guard let exportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetPassthrough) else { return }
                                        exportSession.outputFileType = .m4a
                                        exportSession.outputURL = outputURL
                                        
                                        exportSession.exportAsynchronously {
                                            guard case exportSession.status = AVAssetExportSession.Status.completed else {
                                                toast = Toast(type: .error, title: "No audio", message: "This video has no audio")
                                                return
                                            }
                                            
                                            selectedURL = outputURL
                                            goToAudioCutter = true
                                        }
                                    } catch {
                                        print(error)
                                    }
                                }
                        }
                    }
                }
            }
            
            if showLoading {
                LoadingView()
            }
            
            if let selectedURL = selectedURL, goToAudioCutter {
                NavigationLink(destination: AudioCutterView(url: selectedURL, isCreatedTmp: true), isActive: $goToAudioCutter) {
                    EmptyView()
                }
            }
        }
        .toastView(toast: $toast)
        .onAppear() {
            fetchVideos()
        }
        .navigationBarHidden(true)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(asset: Asset.Colors.colorBG16181C).ignoresSafeArea())
    }
    
    
    // TODO: first application open doesn't get videos when authorized
    func fetchVideos() {
        let semaphore = DispatchSemaphore(value: 1)
        
        showLoading = true
        let format = "mediaType = %d"
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: format, PHAssetMediaType.video.rawValue)
        
        let smartAlbum = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil).firstObject
        
        guard let smartAlbum = smartAlbum else { return }
        
        let fetchResults = PHAsset.fetchAssets(in: smartAlbum, options: fetchOptions)
        
        var videos: [VideosAsset] = []
        let options = PHImageRequestOptions()
        options.resizeMode = .exact
        options.deliveryMode = .highQualityFormat
        
        let dateFormat = DateComponentsFormatter()
        dateFormat.allowedUnits = [.minute, .second]
        dateFormat.zeroFormattingBehavior = .pad
        
        fetchResults.enumerateObjects { object, count, stop in
            PHCachingImageManager.default().requestImage(for: object, targetSize: CGSize(width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.width / 2), contentMode: .aspectFill, options: options) { photo, info in
                let isDegraded = (info?[PHImageResultIsDegradedKey] as? Bool) ?? false
                if isDegraded {
                    return
                }
                
                let options: PHVideoRequestOptions = PHVideoRequestOptions()
                options.version = .original
                options.isNetworkAccessAllowed = true
                
                PHImageManager.default().requestAVAsset(forVideo: object, options: options) { asset, _, _ in
                    if let urlAsset = asset as? AVURLAsset {
                        let videoAsset = VideosAsset(id: count, image: photo, video: object, duration: dateFormat.string(from: object.duration) ?? "00:00", url: urlAsset)
                        videos.append(videoAsset)
                    } else {
                        let videoAsset = VideosAsset(id: count, image: photo, video: object, duration: dateFormat.string(from: object.duration) ?? "00:00", url: nil)
                        videos.append(videoAsset)
                    }
                    
                    if videos.count == fetchResults.count {
                        showLoading = false
                        self.videos = videos.sorted { $0.id > $1.id }
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
    var image: UIImage
    var time: String
    
    var body: some View {
        ZStack {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width / 4, height: UIScreen.main.bounds.width / 4)
            
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
//
//struct VideoGridView_Previews: PreviewProvider {
//    static var previews: some View {
//        VideoGridView(image: "Asd", time: "00:35")
//    }
//}
