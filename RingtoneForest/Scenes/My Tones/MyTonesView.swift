//
//  MyTonesView.swift
//  RingtoneForest
//
//  Created by Thu Truong on 6/21/23.
//

import SwiftUI
import AVKit

struct MyTonesView: View {
    @State var myTones: [MyTone] = []
    
    @State var playingTone: MyTone? = nil
    @State var audioPlayer: AVAudioPlayer? = nil
    @State var progress: Double = 0.0
    
    @State var showLoading = false
    @State var urlToShare: URL = URL(string: "https://test.com")!
    @State var isMakeRingtone = false
    @State var isMakeTrim = false
    @State var isShowRename = false
    @State var isShowDelete = false
    @State var goToTutorial = false
    
    @State var choosenRingtone: MyTone? = nil
    @State var playbackTimer: Timer? = nil
    
    @State var isPlaying = false
    
    @State var toast: Toast? = nil
    
    var body: some View {
        ZStack {
            Image(asset: Asset.Assets.imgBackground)
                .resizable()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text(L10n.myTone)
                        .modifier(TextModifier(color: Asset.Colors.colorGreen69BE15, size: 30, weight: .bold))
                    
                    Spacer()
                    
                    NavigationLink {
                        TutorialView()
                    } label: {
                        Image(asset: Asset.Assets.icQuestion)
                            .background(
                                Color(asset: Asset.Colors.colorTabBG202329)
                                    .blur(radius: 30)
                                    .brightness(0.7)
                                .frame(width: 36, height: 36)
                                .cornerRadius(11)
                            )
                    }

                    
                }
                .padding(.top, 28)
                .padding(.bottom, 36)
                
                if myTones.isEmpty {
                    Spacer()
                    
                    Image(asset: Asset.Assets.imgNoRingtones)
                        .padding(.bottom, 20)
                    
                    Text(L10n.noRingtone)
                        .modifier(TextModifier(color: Asset.Colors.colorGray83868A, size: 12, weight: .medium))
                        .padding(.bottom, 72)
                    
                    FillButtonView(text: L10n.makeNow, width: 182, height: 54, cornerRadius: 15, textSize: 14, textColor: Asset.Colors.colorGreen69BE15, foregroundColor: Asset.Colors.colorGreen69BE15O15) {
                        NotificationCenter.default.post(name: NSNotification.goToMaker, object: nil)
                    }
                    
                    Spacer()
                    
                    Spacer()
                        .frame(height: 60)
                    
                    
                } else {
                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: 20) {
                            ForEach(myTones) { tone in
                                MyTonesRowView(progress: progress, tone: tone, playingTone: $playingTone, isPlaying: audioPlayer?.isPlaying ?? false) {
                                    if playingTone == tone {
                                        if audioPlayer?.isPlaying == true {
                                            audioPlayer?.pause()
                                            audioPlayer?.currentTime = 0
                                        } else {
                                            audioPlayer?.play()
                                        }
                                    } else {
                                        playingTone = tone
                                    }
                                } onOptionsChoiceClick: { options in
                                    switch options {
                                    case .ringtone:
                                        showLoading = true
                                        GarageBandConverter.share(url: RingtoneExtractor.getMyTonePath(name: tone.name), name: tone.name) { exportedURL, error in
                                            showLoading = false
                                            guard let exportedURL = exportedURL else { return }
                                            
                                            urlToShare = exportedURL
                                            isMakeRingtone = true
                                        }
                                    case .trim:
                                        urlToShare = RingtoneExtractor.getMyTonePath(name: tone.name)
                                        isMakeTrim = true
                                    case .rename:
                                        choosenRingtone = tone
                                        isShowRename = true
                                    case .delete:
                                        choosenRingtone = tone
                                        isShowDelete = true
                                    }
                                }

                            }
                        }
                    }
                }
                
                Spacer()
                    .frame(height: 60)
            }
            .padding(.horizontal, 16)
            .onChange(of: playingTone) { tone in
                audioPlayer?.pause()
                progress = 0.0
                
                guard let playingTone = playingTone else { return }
                audioPlayer = try? AVAudioPlayer(contentsOf: RingtoneExtractor.getMyTonePath(name: playingTone.name))
                
                if let audioPlayer = audioPlayer {
                    audioPlayer.play()
                    
                    self.playbackTimer?.invalidate()
                    self.playbackTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { timer in
                        self.isPlaying = audioPlayer.isPlaying
                        
                        if !audioPlayer.duration.isNaN {
                            progress = CGFloat((!audioPlayer.currentTime.isNaN ? audioPlayer.currentTime : 0.0) / audioPlayer.duration)
                        }
                    })
                    
                    RunLoop.current.add(self.playbackTimer!, forMode: .tracking)
                }
            }
            
            if showLoading {
                LoadingView()
            }
            
            if isMakeTrim {
                NavigationLink(destination: AudioCutterView(url: urlToShare, isCreatedTmp: false, fromMyTone: true), isActive: $isMakeTrim) {
                    EmptyView()
                }
            }
            
            if isShowRename {
                RenameView {
                    isShowRename = false
                } onSubmit: { fileName in
                    guard !fileName.isEmpty else {
                        self.hideKeyboard()
                        toast = Toast(type: .error, title: "Missing name", message: "No audio name for file")
                        return
                    }
                    
                    guard ToneCacheCD.shared.isAvailableFor(name: fileName) else {
                        self.hideKeyboard()
                        toast = Toast(type: .error, title: "Name is not available", message: "The file name has already gotten. Please change your file name")
                        return
                    }
                    
                    if let choosenRingtone = choosenRingtone {
                        let destinationPath = RingtoneExtractor.getMyTonePath(name: fileName)
                        
                        if let index = myTones.firstIndex(of: choosenRingtone) {
                            myTones[index].name = fileName
                        }
                        
                        ToneCacheCD.shared.renameTone(tone: choosenRingtone, newName: fileName)
                        do {
                            
                            try FileManager.default.moveItem(at: RingtoneExtractor.getMyTonePath(name: choosenRingtone.name), to: destinationPath)
                            isShowRename = false
                        } catch (let error) {
                            print(error.localizedDescription)
                        }
                    }
                }

            }
            
            if isShowDelete {
                DeleteView {
                    isShowDelete = false
                } onDelete: {
                    if let choosenRingtone = choosenRingtone {
                        if choosenRingtone == playingTone {
                            audioPlayer?.pause()
                        }
                        
                        if let index = myTones.firstIndex(of: choosenRingtone) {
                            myTones.remove(at: index)
                        }
                        
                        ToneCacheCD.shared.deleteTone(toneID: choosenRingtone.id)
                        
                        do {
                            let url = RingtoneExtractor.getMyTonePath(name: choosenRingtone.name)
                            try FileManager.default.removeItem(at: url)
                            isShowDelete = false
                        } catch (let error) {
                            print(error.localizedDescription)
                        }
                    }
                }

            }
        }
        .background(ActivityViewController(activityItems: $urlToShare, isPresented: $isMakeRingtone))
        .toastView(toast: $toast)
        .navigationBarHidden(true)
        .onAppear() {
            fetchTones()
        }
        .onDisappear() {
            audioPlayer?.stop()
        }
    }
    
    func fetchTones() {
        let cacheTones = ToneCacheCD.shared.fetchTones()
        
        var allTones: [MyTone] = []
        if let cacheTones = cacheTones {
            for cacheTone in cacheTones {
                allTones.append(MyTone(id: cacheTone.id!, name: cacheTone.name ?? "", duration: cacheTone.duration))
            }
        }
        
        myTones = allTones
    }
}

struct MyTonesView_Previews: PreviewProvider {
    static var previews: some View {
        MyTonesView()
    }
}

enum OptionsSelection: Int {
    case ringtone, trim, rename, delete
}

struct MyTonesRowView: View {
    var progress: Double
    var tone: MyTone
    
    @Binding var playingTone: MyTone?
    var isPlaying: Bool
    
    var onPlayButtonClick: () -> ()
    var onOptionsChoiceClick: (OptionsSelection) -> ()
    
    @State var showOptions: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 17) {
                Image(asset: Asset.Assets.icRingtoneGreen)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(tone.name)
                        .modifier(TextModifier(color: Asset.Colors.colorWhite, size: 16, weight: .medium))
                    
                    Text(tone.duration.asString())
                        .modifier(TextModifier(color: Asset.Colors.colorGray83868A, size: 12, weight: .medium))
                    
                }
                
                Spacer()
                
                Button {
                    onPlayButtonClick()
                    showOptions = true
                } label: {
                    Image(asset: playingTone == tone && isPlaying ? Asset.Assets.icPauseWhite : Asset.Assets.icPlayWhite)
                }
            }
            .padding(.bottom, 15)
            
            if showOptions {
                VStack {
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color(asset: Asset.Colors.colorGreen69BE15).opacity(0.1))
                            .frame(height: 1)
                        
                            Rectangle()
                                .fill(Color(asset: Asset.Colors.colorGreen69BE15))
                                .frame(height: 2)
                                .frame(width: playingTone == tone ? (UIScreen.main.bounds.width - 32) * progress : 0)
                            
                            Circle()
                                .fill(Color(asset: Asset.Colors.colorGreen69BE15))
                                .frame(width: 9, height: 9)
                                .offset(x: playingTone == tone ? (UIScreen.main.bounds.width - 32) * progress : 0)
                    }
                    .padding(.bottom, 8)
                    
                        HStack {
                            Text((progress * tone.duration).asString())
                                .modifier(TextModifier(color: Asset.Colors.colorGray83868A, size: 12, weight: .medium))
                            
                            Spacer()
                            
                            Text(tone.duration.asString())
                                .modifier(TextModifier(color: Asset.Colors.colorGray83868A, size: 12, weight: .medium))
                        }
                    
                    HStack(spacing: 25) {
                        ButtonIconWithTextView(icon: Asset.Assets.icSetRingtone, text: L10n.setRingtone) {
                            onOptionsChoiceClick(.ringtone)
                        }
                        
                        ButtonIconWithTextView(icon: Asset.Assets.icCutter, text: L10n.cutter) {
                            onOptionsChoiceClick(.trim)
                        }
                        
                        ButtonIconWithTextView(icon: Asset.Assets.icRename, text: L10n.rename) {
                            onOptionsChoiceClick(.rename)
                        }
                        
                        ButtonIconWithTextView(icon: Asset.Assets.icDelete, text: L10n.delete) {
                            onOptionsChoiceClick(.delete)
                        }
                    }
                }
            } else {
                Rectangle()
                    .fill(Color(asset: Asset.Colors.colorGreen69BE15).opacity(0.1))
                    .frame(height: 1)
            }
            
            
            
        }
        .contentShape(Rectangle())
        .onTapGesture {
            showOptions = !showOptions
        }
    }
}

//struct MyTonesRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        MyTonesRowView(name: "Shape of you", time: "00:30")
//    }
//}

struct ButtonIconWithTextView: View {
    var icon: ImageAsset
    var text: String
    var onTap: () -> ()
    
    var body: some View {
        Button {
            onTap()
        } label: {
            VStack(spacing: 2) {
                Image(asset: icon)
                
                Text(text)
                    .modifier(TextModifier(color: Asset.Colors.colorGray83868A, size: 12, weight: .medium))
            }
            .frame(width: 72, height: 72)
        }

        
    }
}

struct ButtonIconWithTextView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonIconWithTextView(icon: Asset.Assets.icSetRingtone, text: L10n.setRingtone) {
            
        }
    }
}
