//
//  VideoExtractorView.swift
//  RingtoneForest
//
//  Created by Thu Truong on 9/13/23.
//

import SwiftUI
import AVKit
import Photos

struct VideoExtractorView: View {
    @Environment(\.presentationMode) var presentationMode
    var asset: VideosAsset
    
    @State var isPlaying = false
    @State var showSuccess = false
    @State var frames: [ImagesAsset] = []
    
    @State var avAsset: AVAsset? = nil
    @State var playerTimer: Timer? = nil
    @State private var offsetLeft = 0.0
    @State private var offsetRight = 0.0
    @State private var offsetBar: Double = -(UIScreen.main.bounds.width / 2) + 47
    @State var currentTime: Double = 0.0
    @State private var duration: Double = 0.0
    
    @State private var leftAccumulated = 0.0
    @State var rightAccumulated = 0.0
    @State var barAccumulated: Double = -(UIScreen.main.bounds.width / 2) + 47
    @State var width = UIScreen.main.bounds.width - 88
    @State var progress: CGFloat = 0.0
    
    @State var player: AVPlayer? = nil
    @State var toast: Toast? = nil
    @State var isPreview = false
    @State var uiImage: UIImage? = nil
    @State var showLoading = false
    
    @State var timer: Timer? = nil
    
    var body: some View {
        let start = Double(offsetLeft * duration / Double(UIScreen.main.bounds.width - 94.0))
        let end = Double(duration + (offsetRight * duration / Double(UIScreen.main.bounds.width - 94.0)))
        let current = Double((offsetBar + UIScreen.main.bounds.width / 2 - 47.0) * duration / Double(UIScreen.main.bounds.width - 94.0))
        
        ZStack {
            WallpaperVideoPlayer(avPlayer: player)
                .ignoresSafeArea()
            
            VStack {
                    HStack {
                        Button {
                            if isPreview {
                                isPreview = false
                            } else {
                                presentationMode.wrappedValue.dismiss()
                            }
                            
                        } label: {
                            Image(asset: Asset.Assets.icBack)
                                .padding(.leading, 16)
                                .contentShape(Rectangle())
                        }
                        
                        Spacer()
                        
                        if !isPreview {
                            FillButtonView(text: L10n.next, width: 73, height: 36, cornerRadius: 11, textSize: 15, textColor: Asset.Colors.colorBlack, foregroundColor: Asset.Colors.colorWhite) {
                                isPreview = true
                                player?.seek(to: CMTime(seconds: start, preferredTimescale: 60000), toleranceBefore: .zero, toleranceAfter: .zero)
                                player?.play()
                            }
                            .padding(.trailing, 16)
                        }
                    }
                    .padding(.top, 23)
                
                if isPreview {
                    VStack {
                        Text(Date().dateFormatted)
                            .modifier(TextModifier(color: Asset.Colors.colorWhite70, size: 20, weight: .bold))
                        
                        Text(Date().timeFormatted)
                            .modifier(TextModifier(color: Asset.Colors.colorWhite70, size: 92, weight: .bold))
                    }
                    
                }
                
                Spacer()
                
                if isPreview {
                    FillButtonView(text: L10n.save, width: UIScreen.main.bounds.width - 40, height: 54, cornerRadius: 15, textSize: 16, textColor: Asset.Colors.colorWhite, foregroundColor: Asset.Colors.colorGreen69BE15) {
                        saveImage()
                    }
                    .padding(.bottom, 32)
                } else {
                    ZStack {
                        HStack(spacing: 0) {
                            Image(asset: Asset.Assets.icCutterLeft)
                                .opacity(0.5)
                            
                            Rectangle()
                                .foregroundColor(Color(asset: Asset.Colors.colorWhite))
                            
                            Image(asset: Asset.Assets.icCutterRight)
                                .opacity(0.5)
                        }
                        .frame(height: 47)
                        
                        HStack(spacing: 0) {
                            ForEach(frames) { frame in
                                Image(uiImage: frame.image)
                                    .resizable()
                                    .frame(width: (UIScreen.main.bounds.width - 88) / CGFloat(frames.count), height: 47)
                            }
                        }
                        .frame(height: 47)
                        
                        HStack(spacing: 0) {
                            Rectangle()
                                .frame(width: offsetLeft + 24, height: 47)
                                .foregroundColor(.clear)
                                .frame(minWidth: 0)
                            
                            Rectangle()
                                .strokeBorder(lineWidth: 3)
                                .frame(width: width, height: 47)
                                .foregroundColor(Color(asset: Asset.Colors.colorWhite))
                                .frame(minWidth: 0)
                            
                            
                            Rectangle()
                                .frame(width: -(offsetRight) + 24, height: 47)
                                .foregroundColor(.clear)
                                .frame(minWidth: 0)
                        }
                        
                        
                        HStack(spacing: 0) {
                            Image(asset: Asset.Assets.icCutterLeft)
                                .frame(width: 24)
                                .offset(x: offsetLeft, y: 0)
                                .gesture(
                                    DragGesture()
                                        .onChanged({ value in
                                            offsetLeft = min(max(0, leftAccumulated + value.translation.width), UIScreen.main.bounds.width - 88 + offsetRight - 6)
                                            
                                            width = UIScreen.main.bounds.width - 88 - offsetLeft + offsetRight
                                            
                                        })
                                        .onEnded({ value in
                                            leftAccumulated = offsetLeft
                                            
                                            player?.seek(to: CMTime(seconds: start, preferredTimescale: 60000), toleranceBefore: .zero, toleranceAfter: .zero)
                                            player?.play()
                                        }))
                            
                            Spacer()
                                .frame(minWidth: 0)
                            
                            Image(asset: Asset.Assets.icCutterRight)
                                .frame(width: 24)
                                .offset(x: offsetRight, y: 0)
                                .gesture(
                                    DragGesture()
                                        .onChanged({ value in
                                            offsetRight = max(min(rightAccumulated + value.translation.width, 0), -(UIScreen.main.bounds.width - 88 - offsetLeft - 6))
                                            
                                            width = UIScreen.main.bounds.width - 88 - offsetLeft + offsetRight
                                        })
                                        .onEnded({ value in
                                            rightAccumulated = offsetRight
                                            
                                            print("offsetRight", offsetRight)
                                            
                                            player?.seek(to: CMTime(seconds: start, preferredTimescale: 60000), toleranceBefore: .zero, toleranceAfter: .zero)
                                            player?.play()
                                        }))
                        }
                        .frame(height: 47)
                        
                        Rectangle()
                            .frame(width: 2, height: 54)
                            .foregroundColor(Color(asset: Asset.Colors.colorWhite))
                            .offset(x: offsetBar, y: 0)
                            .gesture(DragGesture()
                                .onChanged({ value in
                                    offsetBar = max(min(barAccumulated + value.translation.width, UIScreen.main.bounds.width / 2 - 47.0), -(UIScreen.main.bounds.width / 2 - 47.0))
                                })
                                    .onEnded({ value in
                                        barAccumulated = offsetBar
                                        
                                        print("offset Bar", offsetBar)
                                        
                                        print("Seek to", current)
                                        //
                                        player?.seek(to: CMTime(seconds: current, preferredTimescale: 60000), toleranceBefore: .zero, toleranceAfter: .zero)
                                        player?.play()
                                    })
                            )
                        
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 32)
                    
                }
            }
            
            if showLoading {
                LoadingView()
            }
            
            if showSuccess {
                SavingView()
            }
        }
        .navigationBarHidden(true)
        .toastView(toast: $toast)
        .onChange(of: progress) { newValue in
            offsetBar = progress * Double(UIScreen.main.bounds.width - 94.0) + 47.0 - UIScreen.main.bounds.width / 2
        }
        .onAppear() {
            asset.video.getVideoFrames { images, asset in
                if let images = images {
                    frames = images.map { ImagesAsset(image: $0) }
                }
                
                if !frames.isEmpty {
                    uiImage = frames[0].image
                }
                
                if let asset = asset {
                    avAsset = asset
                    let playerItem = AVPlayerItem(asset: asset)
                    player = AVPlayer(playerItem: playerItem)
                    player?.play()
                    
                    if let videoPlayer = player, let currentItem = videoPlayer.currentItem {
                        self.playerTimer?.invalidate()
                        DispatchQueue.main.async {
                            self.playerTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { timer in
                                if self.player?.timeControlStatus == .paused {
                                    self.isPlaying = true
                                } else {
                                    self.isPlaying = false
                                }
                                
                                if !currentItem.duration.seconds.isNaN {
                                    self.duration = currentItem.duration.seconds
                                    self.progress = CGFloat(!currentItem.currentTime().seconds.isNaN ? currentItem.currentTime().seconds : 0.0) / currentItem.duration.seconds
                                }
                                
                                let currentTime = (!currentItem.currentTime().seconds.isNaN ? currentItem.currentTime().seconds : 0.0)
                                let end = Double(duration + (offsetRight * duration / Double(UIScreen.main.bounds.width - 94.0)))
                                
                                if currentTime.roundToDecimal(1) == end.roundToDecimal(1) {
                                    videoPlayer.pause()
                                }
                            })
                            
                            RunLoop.current.add(self.playerTimer!, forMode: .tracking)
                        }
                    }
                }
            }
        }
        .onDisappear() {
            self.playerTimer?.invalidate()
        }
    }
    
    func requestAuthorization(completion: @escaping () -> Void) {
        if PHPhotoLibrary.authorizationStatus() == .notDetermined {
            print("Not determined")
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    completion()
                }
            }
        } else if PHPhotoLibrary.authorizationStatus() == .authorized {
            completion()
        }
    }
    
    func saveImage() {
        guard let avAsset = avAsset else { return }
        
        showLoading = true
        
        requestAuthorization {
            let playerItem = AVPlayerItem(asset: avAsset)
            LivePhoto.generate(from: nil, videoURL: playerItem.url!) { progress in
                
            } completion: { livePhoto, resource in
                if livePhoto != nil, let resource = resource {
                    LivePhoto.saveToLibrary(resource) { success in
                        showLoading = false
                        if success {
                            showSuccess = true
                            
                            timer?.invalidate()
                            DispatchQueue.main.async {
                                timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { timer in
                                    
                                    showSuccess = false
                                    
                                    
                                    timer.invalidate()
                                    
                                    presentationMode.wrappedValue.dismiss()
                                }}
                            print("Download success")
                        } else {
                            toast = Toast(type: .error, title: "Download failed", message: "Your wallpaper download has failed")
                            print("Download failed")
                        }
                    }
                    
                } else {
                    showLoading = false
                    toast = Toast(type: .error, title: "Download failed", message: "Your wallpaper download has failed")
                    print("Download failed")
                }
            }
            
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

//struct VideoExtractorView_Previews: PreviewProvider {
//    static var previews: some View {
//        VideoExtractorView()
//    }
//}
