//
//  WallpaperDetailView.swift
//  RingtoneForest
//
//  Created by Thu Trương on 23/07/2023.
//

import SwiftUI
import NukeUI
import mobileffmpeg
import AVKit
import Photos

struct WallpaperDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var isPreview = false
    
    var wallpaper: Wallpaper
    @State var player: AVPlayer? = nil
    @State var showLoading = false
    
    @State var toast: Toast? = nil
    @State var showSuccess = false
    
    @State var timer: Timer? = nil
    
    var body: some View {
        ZStack {
            ZStack {
                if wallpaper.filename.suffix(4).contains("mp4") || wallpaper.filename.suffix(4).contains("mov") {
                    LoadingView()
                    
                    WallpaperVideoPlayer(avPlayer: player)
                        .ignoresSafeArea()
                        .onAppear() {
                            print(wallpaper.filename)
                            player?.play()
                        }
                } else {
                    LoadingView()
                    
                    VLCPlayerView(url: URL(string: wallpaper.filename)!)
                        .ignoresSafeArea()
                }
            }
            .onTapGesture {
                isPreview = false
            }
            
            VStack(spacing: 0) {
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(asset: Asset.Assets.icClose)
                            .contentShape(Rectangle())
                    }
                    
                    Spacer()
                    
                }
                .padding(.horizontal, 16)
                .padding(.top, 23)
                .padding(.bottom, 20)
                
                if isPreview {
                    VStack {
                        Text(Date().dateFormatted)
                            .modifier(TextModifier(color: Asset.Colors.colorWhite70, size: 20, weight: .bold))
                        
                        Text(Date().timeFormatted)
                            .modifier(TextModifier(color: Asset.Colors.colorWhite70, size: 92, weight: .bold))
                    }
                    
                }
                
                Spacer()
                
                ZStack {
                    Button {
                        if !isFileDownloaded(fileName: wallpaper.filename) {
                            let tasks = AppDelegate.instance.sessionManager.multiDownload([wallpaper.thumbnail, wallpaper.filename]).progress { (task) in
                                
                            }
                            
                            showLoading = true
                            
                            var success = false
                            
                            let dispatchGroup = DispatchGroup()
                            for task in tasks {
                                dispatchGroup.enter()
                                task.completion { task in
                                    if task.status == .succeeded {
                                        dispatchGroup.leave()
                                        success = true
                                    } else if task.status == .canceled || task.status == .failed {
                                        dispatchGroup.leave()
                                        success = false
                                    }
                                }
                            }
                            
                            dispatchGroup.notify(queue: .main) {
                                if success {
                                    saveImage()
                                } else {
                                    showLoading = false
                                    toast = Toast(type: .error, title: "Download failed", message: "Your wallpaper download has failed")
                                    print("Download failed")
                                }
                                
                                
                            }
                        } else {
                            saveImage()
                        }
                    } label: {
                        Image(asset: Asset.Assets.icDownload)
                            .contentShape(Rectangle())
                    }
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            isPreview = !isPreview
                        } label: {
                            Image(asset: Asset.Assets.icPreview)
                                .padding(.trailing, 63)
                                .contentShape(Rectangle())
                        }
                        
                        
                    }
                }
                .padding(.bottom, 30)
            }
            
            if showLoading {
                LoadingView()
            }
            
            if showSuccess {
                SavingView()
            }
        }
        .onAppear() {
            if wallpaper.filename.suffix(4).contains("mp4") || wallpaper.filename.suffix(4).contains("mov") {
                player = AVPlayer(url: URL(string: wallpaper.filename)!)
            }
        }
        .toastView(toast: $toast)
        .navigationBarHidden(true)
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
    
    func convertWebmToMp4(webmURL: URL, completion: @escaping (URL?) -> Void) {
        let name = webmURL.deletingPathExtension().lastPathComponent
        let outputURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(name + ".mp4")
        if FileManager.default.fileExists(atPath: outputURL.path) {
            completion(outputURL)
        } else {
            let execution = MobileFFmpeg.execute("-i \(webmURL.absoluteString) -an \(outputURL.path)")
            
            if execution == RETURN_CODE_SUCCESS {
                completion(outputURL)
            } else {
                completion(nil)
            }
        }
    }
    
    func saveImage() {
        showLoading = true
        
        if wallpaper.filename.suffix(4).contains("mp4") || wallpaper.filename.suffix(4).contains("mov") {
            requestAuthorization {
                LivePhoto.generate(from: URL(fileURLWithPath: AppDelegate.instance.sessionManager.cache.filePath(url: wallpaper.thumbnail) ?? ""), videoURL: URL(fileURLWithPath: AppDelegate.instance.sessionManager.cache.filePath(url: wallpaper.filename) ?? "")) { progress in
                    
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
        } else {
            convertWebmToMp4(webmURL: URL(fileURLWithPath: AppDelegate.instance.sessionManager.cache.filePath(url: wallpaper.filename) ?? "")) { videoURL in
                guard let videoURL = videoURL else {
                    toast = Toast(type: .error, title: "Download failed", message: "Your wallpaper download has failed")
                    print("Download failed")
                    return
                }
                
                requestAuthorization {
                    LivePhoto.generate(from: URL(fileURLWithPath: AppDelegate.instance.sessionManager.cache.filePath(url: wallpaper.thumbnail) ?? ""), videoURL: videoURL) { progress in
                        
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
        }
    }
}

func isFileDownloaded(fileName: String) -> Bool {
    return AppDelegate.instance.sessionManager.cache.fileExists(url: fileName)
}

//struct WallpaperDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        WallpaperDetailView(wallpaper: Wallpaper(id: <#T##Int#>, filename: <#T##String#>, thumbnail: <#T##String#>, premium: <#T##Bool?#>, categoryId: <#T##Int?#>))
//    }
//}
