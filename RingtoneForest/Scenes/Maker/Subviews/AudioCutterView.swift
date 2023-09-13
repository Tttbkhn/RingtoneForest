//
//  AudioCutterView.swift
//  RingtoneForest
//
//  Created by Thu Trương on 25/06/2023.
//

import SwiftUI
import AVFoundation
import SwiftUIIntrospect

struct PowerLevel: Identifiable {
    let id: Int
    let output: Float
}

struct AudioCutterView: View {
    @Environment(\.presentationMode) var presentationMode
    var url: URL
    var isCreatedTmp: Bool
    @State var avPlayer: AVPlayer? = nil
    @State var playerTimer: Timer? = nil
    
    @State var duration: Double = 0.0
    @State var durationTimeCalibration: Double = 30.0
    @State var isFadeIn = false
    @State var isFadeOut = false
    @State var progress: CGFloat = 0.0
    @State var fakeProgress: CGFloat = 0.0
    
    @State var isPlaying = false
    @State var outputArr: [PowerLevel] = []
    
    // 32 is horizontal padding
    @State var width = UIScreen.main.bounds.width - 32
    @State var offsetBar: Double = 0.0
    @State var offsetBarForScroll: Double = 0.0
    @State var offsetBarAccumulated: Double = 0.0
    @State var offsetBarSlider: Double = 0.0
    @State var isSliderBarEdit = false
    @State var offsetBarSliderAccumulated: Double = 0.0
    @State var offsetLeft = 0.0
    @State var leftAccumulated = 0.0
    @State var offsetRight = 0.0
    @State var rightAccumulated = 0.0
    @State var isWaveformLoaded = false
    
    @State var isLeftBarEnable = true
    @State var isMiddleBarEnable = true
    @State var isRightBarEnable = true
    
    @State var testProxy = 0.0
    @State var testCurrentTime = ""
    
    @State var fadeInPosition: [Double] = []
    @State var fadeOutPosition: [Double] = []
    @State var showRingtoneSave = false
    
    @State var showLoading = false
    @State var toast: Toast? = nil
    @State var goToOutputFolder = false
    
    var fromMyTone: Bool
    
    var body: some View {
        let horizontalPadding: CGFloat = 32
        let screenWidth = UIScreen.main.bounds.width
        let cutterBarWidth: Double = 24
        let height: CGFloat = 217
        let currentBarWidth: Double = 8.56
        let waveformLength = Double(screenWidth - horizontalPadding)
        
        let offsetForStart = testProxy / waveformLength * 30
        
        let start = Double(offsetLeft / waveformLength * 30 + offsetForStart)
        let end = Double((offsetRight + waveformLength) / waveformLength * 30 + offsetForStart)
        
        ZStack {
            Image(asset: Asset.Assets.imgBackground)
                .resizable()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                ZStack {
                    HStack {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image(asset: Asset.Assets.icBack)
                                .padding(.leading, 16)
                                .contentShape(Rectangle())
                        }
                        
                        Spacer()
                    }
                    
                    
                    Text(L10n.audioCutter)
                        .modifier(TextModifier(color: Asset.Colors.colorWhite90, size: 20, weight: .bold))
                }
                .frame(height: 55)
                
                Text(L10n.maxLength)
                    .modifier(TextModifier(color: Asset.Colors.colorGrayBCBCBC, size: 14, weight: .regular))
                    .padding(.top, 5)
                    .padding(.bottom, 43)
                
                HStack {
                    timeView(label: L10n.start, time: start.asString(), alignment: .leading)
                    
                    Spacer()
                    
                    timeView(label: L10n.duration, time: durationTimeCalibration.asString(), alignment: .center)
                    
                    Spacer()
                    
                    timeView(label: L10n.end, time: end.asString(), alignment: .trailing)
                }
                .padding(.horizontal, 16)
                
                    ZStack(alignment: .leading) {
                        ScrollViewReader { reader in
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack(spacing: 2) {
                                    ForEach(Array(outputArr.enumerated()), id: \.element.id) { index, output in
                                        RoundedRectangle(cornerRadius: 10)
                                            .frame(width: 1, height: output.output < 0 ? 1 : CGFloat(output.output * 2))
                                            .foregroundColor(Color(asset: Asset.Colors.colorGreen69BE15))
                                            .id(output.id)
                                    }
                                }
                                    .background(GeometryReader { proxy in
                                        Color.clear.preference(key: ScrollViewOffsetPreferenceKey.self, value: -proxy.frame(in: .named("scroll")).origin.x)
                                        
                                    })
                                    .background(GeometryReader { proxy in
                                        Color.clear
                                            .onAppear {
                                                testProxy = proxy.size.width
                                            }
                                    })
                                    .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) {
                                        testProxy = $0
                                    }
                            }
                            .coordinateSpace(name: "scroll")
                            .introspect(.scrollView, on: .iOS(.v14, .v15, .v16, .v17), customize: { scrollView in
                                scrollView.bounces = false
                            })
                            .onChange(of: offsetBarForScroll, perform: { newValue in
                                print("Change offset bar", newValue)
                                if outputArr.contains { $0.id == Int(newValue) } {
                                    reader.scrollTo(Int(newValue))
                                }
                            })
                        }
                        
                        Rectangle()
                            .fill(Color(asset: Asset.Colors.colorGreen69BE15).opacity(0.15))
                            .frame(width: width, height: height)
                            .offset(x: offsetLeft)
                            .allowsHitTesting(false)
                        
                        HStack(spacing: 0) {
                            Image(asset: Asset.Assets.icCutterBar)
                            //                            .background(Color.blue)
                                .offset(x: offsetLeft - cutterBarWidth / 2)
                                .gesture(
                                    DragGesture()
                                        .onChanged({ value in
                                            // 6 here is for calculation calibration
                                            let calibration: Double = 0
                                            let maxValueWithoutCalibration = screenWidth - (horizontalPadding / 2) - (cutterBarWidth / 2)
                                            let maxValue = maxValueWithoutCalibration - calibration
                                            offsetLeft = min(max(0, leftAccumulated + value.translation.width), maxValue)
                                            
                                            width = screenWidth - horizontalPadding - offsetLeft + offsetRight
                                            
                                            durationTimeCalibration = Double(Int(end) - Int(start))
                                        })
                                        .onEnded({ value in
                                            leftAccumulated = offsetLeft
                                        })
                                )
                            
                            Spacer()
                                .frame(minWidth: 0)
                            
                            Image(asset: Asset.Assets.icCutterBar)
                            //                            .background(Color.red)
                                .offset(x: offsetRight + cutterBarWidth / 2)
                                .gesture(
                                    DragGesture()
                                        .onChanged({ value in
                                            offsetRight = max(min(rightAccumulated + value.translation.width, 0), -(screenWidth - horizontalPadding))
                                            
                                            width = screenWidth - horizontalPadding - offsetLeft + offsetRight
                                            
                                            durationTimeCalibration = Double(Int(end) - Int(start))
                                        })
                                        .onEnded({ value in
                                            rightAccumulated = offsetRight
                                        })
                                )
                        }
                        
                        Image(asset: Asset.Assets.icCurrentBar)
                            .offset(x: offsetBar - currentBarWidth / 2)
                            .gesture(
                                DragGesture()
                                    .onChanged({ value in
                                        offsetBar = max(min(offsetBarAccumulated + value.translation.width, screenWidth - horizontalPadding), 0)
                                    })
                                    .onEnded({ value in
                                        offsetBarAccumulated = offsetBar
                                    })
                            )
                }
                    
                
                .frame(height: 217)
                .padding(.top, 17)
                .padding(.bottom, 35)
                .padding(.horizontal, 16)
                
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color(asset: Asset.Colors.colorGreen69BE15).opacity(0.3))
                        .frame(height: 1)
                        .padding(.horizontal, 10)
                    
                    Rectangle()
                        .fill(Color(asset: Asset.Colors.colorGreen69BE15))
                        .frame(height: 3)
                        .frame(width: offsetBarSlider)
                        .padding(.horizontal, 10)
                    
                    ZStack {
                        Rectangle()
                            .fill(Color(asset: Asset.Colors.colorGreen69BE15))
                            .frame(width: 3, height: 20)
                    }
                    .frame(width: 20, height: 20)
                    .contentShape(Rectangle())
//                    .gesture(
//                        DragGesture(coordinateSpace: .global)
//                            .onChanged({ value in
//                                print("value.translation.width", value.translation.width)
//                                isSliderBarEdit = true
//                                let progress = (offsetBarSliderAccumulated + value.translation.width) / (screenWidth - horizontalPadding)
//                                if progress >= 0 && progress <= 1 {
//                                    print("Progress", progress)
//                                    self.progress = progress
//                                    self.fakeProgress = progress
//                                    
//                                    offsetBarSlider = offsetBarSliderAccumulated + value.translation.width
//                                    
//                                    print("OffsetBar slider", offsetBarSlider)
//                                    
//                                    offsetBarForScroll = progress * (duration / 30) * waveformLength
//                                }
//                            })
//                            .onEnded({ value in
//                                offsetBarSliderAccumulated = offsetBarSlider
//                                let seconds = offsetBarSliderAccumulated / (screenWidth - horizontalPadding) * duration
//                                avPlayer?.seek(to: CMTime(seconds: seconds, preferredTimescale: 60000), toleranceBefore: .zero, toleranceAfter: .zero)
//                                
//                                isSliderBarEdit = false
//                                
//                                print("offsetBarSlider", offsetBarSlider)
//                                
//                                let progress = (offsetBarSliderAccumulated + value.translation.width) / (screenWidth - horizontalPadding)
////                                if progress >= 0 && progress <= 1 {
////                                    print("Progress", progress)
////                                    self.progress = progress
////                                    self.fakeProgress = progress
////
////                                    print("OffsetBar slider", offsetBarSlider)
////
////                                    offsetBarForScroll = progress * (duration / 30) * waveformLength
////                                }
////                                print("Offset Bar End", )
//                            })
//                    )
                    .offset(x: offsetBarSlider)
                }
                .padding(.horizontal, 6)
                
                fadeView()
                
                Button {
                    if isPlaying {
                        avPlayer?.pause()
                    } else {
                        avPlayer?.seek(to: CMTime(seconds: start, preferredTimescale: 60000), toleranceBefore: .zero, toleranceAfter: .zero)
                        avPlayer?.play()
                    }
                } label: {
                    Image(asset: isPlaying ? Asset.Assets.icPauseRecord : Asset.Assets.icPlayRecord)
                        .padding(.bottom, 32)
                }
                
                NoFillButtonView(text: L10n.saveRingtone, width: 238, height: 60, cornerRadius: 14, textSize: 17, color: Asset.Colors.colorGreen69BE15, lineWidth: 2) {
                    showRingtoneSave = true
                }
                .padding(.bottom, 40)
                
                
            }
            .frame(maxWidth: .infinity)
            
            if showRingtoneSave {
                SaveRingtoneView {
                    showRingtoneSave = false
                } onOk: { audioName in
                    showLoading = true
                    
                    guard !audioName.isEmpty else {
                        showLoading = false
                        toast = Toast(type: .error, title: "Missing name", message: "No audio name for file")
                        return
                    }
                    
                    guard ToneCacheCD.shared.isAvailableFor(name: audioName) else {
                        showLoading = false
                        toast = Toast(type: .error, title: "Name is not available", message: "The file name has already gotten. Please change your file name")
                        return
                    }
                    
                    let asset = AVAsset(url: url)
                    
                    Task {
                        await RingtoneExtractor.shared.trimAudio(asset: asset, outputFileName: audioName, startTime: start, stopTime: end, fadeIn: isFadeIn, fadeOut: isFadeOut, finished: { status in
                            showRingtoneSave = false
                            showLoading = false
                            switch status {
                            case .failed:
                                toast = Toast(type: .error, title: "Failed", message: "Save ringtone failed. Please try again")
                            case .completed:
                                toast = Toast(type: .success, title: "Success", message: "Ringtone saved successfully to output folder")
                                if isCreatedTmp {
                                    RingtoneExtractor.shared.removeFileIfExists(fileURL: url.path)
                                }
                                
                                if fromMyTone {
                                    presentationMode.wrappedValue.dismiss()
                                } else {
                                    DispatchQueue.main.async {
                                        NotificationCenter.default.post(name: NSNotification.goToMyTone, object: ["fromMake": true])
                                    }
                                }
                                
                            default: break
                            }
                        })
                    }
                }

            }
            
            if goToOutputFolder {
                NavigationLink(destination: MyTonesView(), isActive: $goToOutputFolder) {
                    EmptyView()
                }
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .navigationBarHidden(true)
        .onChange(of: progress, perform: { newValue in
            if !isSliderBarEdit {
                offsetBarSlider = progress * waveformLength
            }
            
            let offset = progress * (duration / 30) * waveformLength
            let offsetForStart = testProxy / waveformLength * 30
            offsetBar = offset - testProxy
            print("offsetBar", offsetBar)
        })
//        .onChange(of: fakeProgress, perform: { newValue in
//            let offset = progress * (duration / 30) * waveformLength
//            if offset < waveformLength {
//                offsetBar = offset
//            } else {
//                offsetBar = waveformLength
//            }
//            print("offsetBar", offsetBar)
//        })
        .toastView(toast: $toast)
        .onAppear() {
            let playerItem = AVPlayerItem(url: url)
            avPlayer = AVPlayer(playerItem: playerItem)
            
            if let avPlayer = avPlayer, let currentItem = avPlayer.currentItem {
                self.playerTimer?.invalidate()
                
                playerTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { timer in
                    if avPlayer.timeControlStatus == .paused {
                        isPlaying = false
                    } else {
                        isPlaying = true
                    }
                    
                    if (!currentItem.duration.seconds.isNaN) {
                        if !isWaveformLoaded {
                            duration = currentItem.duration.seconds
                            Task {
                                do {
                                    let calibration = 1
                                    let fullSpace = waveformLength / 30 * duration
                                    let samplesLength = Int((fullSpace + 2) / 3) + calibration
                                    
                                    try await AudioContext.load(fromAudioURL: url, completionHandler: { audioContext in
                                        guard let audioContext = audioContext else {
                                            fatalError("Couldn't create audioContext")
                                        }
                                        let outputArr = render(audioContext: audioContext, targetSamples: samplesLength).map { $0 + 80 }
                                        
                                        self.outputArr = outputArr.enumerated().map { (index, level) in
                                            PowerLevel(id: index + index * 2, output: level) }
                                        
                                        print("Output", self.outputArr)
                                    })
                                }
                            }
                            isWaveformLoaded = true
                        }
                        
                        let currentTime = (!currentItem.currentTime().seconds.isNaN ? currentItem.currentTime().seconds : 0.0)
                        testCurrentTime = currentTime.asString()
                        let notGoodProgress = CGFloat(currentTime / currentItem.duration.seconds)
                        if !isSliderBarEdit {
                            progress = notGoodProgress <= 0 ? 0 : notGoodProgress
                        }
                        fakeProgress = notGoodProgress <= 0 ? 0 : notGoodProgress
                        let offsetForStart = testProxy / waveformLength * 30
                        let end = Double((offsetRight + waveformLength) / waveformLength * 30 + offsetForStart)
                        if currentTime.roundToDecimal(1) == end.roundToDecimal(1) {
                            avPlayer.pause()
                        }
                        
                        if isFadeIn {
                            if fadeInPosition.contains(currentTime.roundToDecimal(1)) {
                                avPlayer.volume = Float((currentTime.roundToDecimal(1) - fadeInPosition.first!) / 2)
                            }
                        }
                        
                        if isFadeOut {
                            if fadeOutPosition.contains(currentTime.roundToDecimal(1)) {
                                avPlayer.volume = Float((fadeOutPosition.last! - currentTime.roundToDecimal(1)) / 2)
                            }
                        }
                        
//                        let offset = notGoodProgress * (duration / 30) * waveformLength
//                        offsetBarForScroll = offset
//                        print("offsetBarForScroll", offset)
                    }
                })
                
                RunLoop.current.add(playerTimer!, forMode: .tracking)
            }
            
            
        }
        .onDisappear() {
            self.playerTimer?.invalidate()
        }
    }
    
    func getFadeInPosition(startTime: Double) {
        fadeInPosition.removeAll()
        
        for i in stride(from: startTime, through: startTime + 2.0, by: 0.2) {
            fadeInPosition.append(i.roundToDecimal(1))
        }
    }
    
    func getFadeOutPosition(endTime: Double) {
        fadeOutPosition.removeAll()
        
        for i in stride(from: endTime - 2.0, through: endTime, by: 0.2) {
            fadeOutPosition.append(i.roundToDecimal(1))
        }
    }
    
    
    func outputArrayView() -> some View {
        HStack(spacing: 2) {
            ForEach(Array(outputArr.enumerated()), id: \.element.id) { index, output in
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 1, height: output.output < 0 ? 1 : CGFloat(output.output * 2))
                    .foregroundColor(Color(asset: Asset.Colors.colorGreen69BE15))
            }
        }
    }
    
    @ViewBuilder
    func fadeView() -> some View {
        Spacer()
        
        HStack {
            HStack(spacing: 10) {
                Text(L10n.fadeIn)
                    .modifier(TextModifier(color: Asset.Colors.colorWhite, size: 14, weight: .medium))
                
                Toggle("", isOn: $isFadeIn)
                    .labelsHidden()
                    .onChange(of: isFadeIn) { newValue in
                        let horizontalPadding: CGFloat = 32
                        let screenWidth = UIScreen.main.bounds.width
                        let waveformLength = Double(screenWidth - horizontalPadding)
                        
                        let offsetForStart = testProxy / waveformLength * 30
                        let start = Double(offsetLeft / waveformLength * 30 + offsetForStart)
                        
                        if newValue {
                            getFadeInPosition(startTime: start)
                        } else {
                            avPlayer?.volume = 1
                        }
                        
                        avPlayer?.seek(to: CMTime(seconds: start, preferredTimescale: 60000), toleranceBefore: .zero, toleranceAfter: .zero)
                        avPlayer?.play()
                    }
            }
            
            
            Spacer()
            
            HStack(spacing: 10) {
                Toggle("", isOn: $isFadeOut)
                    .labelsHidden()
                    .onChange(of: isFadeOut) { newValue in
                        let horizontalPadding: CGFloat = 32
                        let screenWidth = UIScreen.main.bounds.width
                        let waveformLength = Double(screenWidth - horizontalPadding)
                        
                        let offsetForStart = testProxy / waveformLength * 30
                        let end = Double((offsetRight + waveformLength) / waveformLength * 30 + offsetForStart)
                        
                        if newValue {
                            getFadeOutPosition(endTime: end)
                        } else {
                            avPlayer?.volume = 1
                        }
                        
                        avPlayer?.seek(to: CMTime(seconds: end - 5, preferredTimescale: 60000), toleranceBefore: .zero, toleranceAfter: .zero)
                        avPlayer?.play()
                    }
                
                Text(L10n.fadeOut)
                    .modifier(TextModifier(color: Asset.Colors.colorWhite, size: 14, weight: .medium))
            }
            
        }
        .padding(.horizontal, 16)
        
        Spacer()
    }
    
    @ViewBuilder
    func timeView(label: String, time: String, alignment: HorizontalAlignment) -> some View {
        
        VStack(alignment: alignment, spacing: 4) {
            Text(label)
                .modifier(TextModifier(color: Asset.Colors.colorGray83868A, size: 12, weight: .medium))
            
            Text(time)
                .modifier(TextModifier(color: Asset.Colors.colorGrayCFCFCF, size: 12, weight: .medium))
        }
        .frame(width: (alignment == .leading || alignment == .trailing) ? 40 : 60, alignment: alignment == .leading ? .leading : .trailing)
    }
}

struct AudioCutterView_Previews: PreviewProvider {
    static var previews: some View {
        AudioCutterView(url: Bundle.main.url(forResource: "sample_2", withExtension: "mp3")!, isCreatedTmp: false, fromMyTone: false)
    }
}
