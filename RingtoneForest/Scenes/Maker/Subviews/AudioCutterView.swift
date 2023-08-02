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
    let id = UUID()
    let output: Float
}

struct AudioCutterView: View {
    @Environment(\.presentationMode) var presentationMode
    var url: URL
    @State var avPlayer: AVPlayer? = nil
    @State var playerTimer: Timer? = nil
    @State var timeStart = "00:00"
    
    @State var duration: Double = 0.0
    @State var timeEnd = "00:00"
    @State var isFadeIn = false
    @State var isFadeOut = false
    @State var progress: CGFloat = 0.0
    
    @State var isPlaying = false
    @State var outputArr: [PowerLevel] = []
    
    // 32 is horizontal padding
    @State var width = UIScreen.main.bounds.width - 32
    @State var offsetBar: Double = 0.0
    @State var offsetBarAccumulated: Double = 0.0
    @State var offsetBarSlider: Double = 0.0
    @State var isSliderBarEdit = false
    @State var offsetBarSliderAccumulated: Double = 0.0
    @State var offsetLeft = 0.0
    @State var leftAccumulated = 0.0
    @State var offsetRight = 0.0
    @State var rightAccumulated = 0.0
    
    @State var testProxy = 0.0
    @State var testCurrentTime = ""
    
    var body: some View {
        let horizontalPadding: CGFloat = 32
        let screenWidth = UIScreen.main.bounds.width
        let cutterBarWidth: Double = 24
        let height: CGFloat = 217
        let currentBarWidth: Double = 8.56
        
        let start = Double(offsetLeft * duration / Double(screenWidth - horizontalPadding))
        
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
                    
                    timeView(label: L10n.duration, time: "00:00", alignment: .center)
                    
                    Spacer()
                    
                    timeView(label: L10n.end, time: timeEnd, alignment: .trailing)
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
                            .onChange(of: outputArr.count, perform: { _ in
                                if let lastId = outputArr.last?.id {
                                    reader.scrollTo(lastId)
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
                                            let calibration: Double = 6
                                            let maxValueWithoutCalibration = screenWidth - (horizontalPadding / 2) - (cutterBarWidth / 2)
                                            let maxValue = maxValueWithoutCalibration - calibration
                                            offsetLeft = min(max(0, leftAccumulated + value.translation.width), maxValue)
                                            
                                            width = screenWidth - horizontalPadding - offsetLeft + offsetRight
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
                
                                
                Text("\(UIScreen.main.bounds.width - horizontalPadding)")
                    .foregroundColor(Color.white)
                
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
                    .gesture(
                        DragGesture(coordinateSpace: .global)
                            .onChanged({ value in
                                print("value.translation.width", value.translation.width)
                                isSliderBarEdit = true
                                let progress = (offsetBarSliderAccumulated + value.translation.width) / (screenWidth - horizontalPadding)
                                if progress >= 0 && progress <= 1 {
                                    print("Progress", progress)
                                    self.progress = progress
                                    
                                    offsetBarSlider = offsetBarSliderAccumulated + value.translation.width
                                    
                                    print("OffsetBar slider", offsetBarSlider)
                                }
                            })
                            .onEnded({ value in
                                offsetBarSliderAccumulated = offsetBarSlider
                                avPlayer?.seek(to: CMTime(seconds: offsetBarSliderAccumulated / (screenWidth - horizontalPadding) * duration, preferredTimescale: 60000), toleranceBefore: .zero, toleranceAfter: .zero)
                                
                                isSliderBarEdit = false
                                
                                print("offsetBarSlider", offsetBarSlider)
                            })
                    )
                    .offset(x: offsetBarSlider)
                }
                .padding(.horizontal, 6)
                
                fadeView()
                
                Button {
                    if isPlaying {
                        avPlayer?.pause()
                    } else {
//                        avPlayer?.seek(to: CMTime(seconds: 0, preferredTimescale: 60000), toleranceBefore: .zero, toleranceAfter: .zero)
                        avPlayer?.play()
                    }
                } label: {
                    Image(asset: isPlaying ? Asset.Assets.icPauseRecord : Asset.Assets.icPlayRecord)
                        .padding(.bottom, 32)
                }
                
                NoFillButtonView(text: L10n.saveRingtone, width: 238, height: 60, cornerRadius: 14, textSize: 17, color: Asset.Colors.colorGreen69BE15, lineWidth: 2) {
                    
                }
                .padding(.bottom, 40)
                
                
            }
            .frame(maxWidth: .infinity)
        }
        .navigationBarHidden(true)
        .onChange(of: progress, perform: { newValue in
            if !isSliderBarEdit {
                offsetBarSlider = progress * (screenWidth - horizontalPadding)
            }
        })
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
                        duration = currentItem.duration.seconds
                        let currentTime = (!currentItem.currentTime().seconds.isNaN ? currentItem.currentTime().seconds : 0.0)
                        testCurrentTime = currentTime.asString()
                        let notGoodProgress = CGFloat(currentTime / currentItem.duration.seconds)
                        progress = notGoodProgress <= 0 ? 0 : notGoodProgress
                        
                    }
                })
                
                RunLoop.current.add(playerTimer!, forMode: .tracking)
            }
            
            Task {
                do {
                    try await AudioContext.load(fromAudioURL: url, completionHandler: { audioContext in
                        guard let audioContext = audioContext else {
                            fatalError("Couldn't create audioContext")
                        }
                        let outputArr = render(audioContext: audioContext, targetSamples: 1000).map { $0 + 80 }
                        print("Max", outputArr.max())
                        print("Count", outputArr.count)
                        print("Output", outputArr)
                        
                        self.outputArr = outputArr.map { PowerLevel(output: $0) }
                    })
                }
            }
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
            }
            
            
            Spacer()
            
            HStack(spacing: 10) {
                Toggle("", isOn: $isFadeOut)
                    .labelsHidden()
                
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
    }
}

struct AudioCutterView_Previews: PreviewProvider {
    static var previews: some View {
        AudioCutterView(url: Bundle.main.url(forResource: "sample", withExtension: "mp3")!)
    }
}
