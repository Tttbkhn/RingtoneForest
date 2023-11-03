//
//  RecordAudioView.swift
//  RingtoneForest
//
//  Created by Thu Truong on 6/23/23.
//

import SwiftUI
import AVKit

struct FloatData: Identifiable, Hashable {
    let id = UUID().uuidString
    let data: Float
}

struct RecordAudioView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var currentTime: Double = 0.0
    @State var isRecording = false
    @State var doneRecording = false
    
    @State var session: AVAudioSession!
    @State var recorder: AVAudioRecorder!
    @State var isPlaying = false
    
    @State var audioPlayer: AVAudioPlayer? = nil
    
    @State var timer = Timer.publish(every: 0.02, on: .main, in: .common).autoconnect()
    
    @State var volumeArr: [FloatData] = []
    @State var arrIndex = 0
    
    @State var goToAudioCutter = false
    
    var body: some View {
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
                    
                    Text(L10n.recordAudio)
                        .modifier(TextModifier(color: Asset.Colors.colorWhite90, size: 20, weight: .bold))
                }
                .frame(height: 55)
                
                Text(currentTime.asFullString())
                    .modifier(TextModifier(color: Asset.Colors.colorWhite, size: 30, weight: .regular))
                    .padding(.top, 100)
                
                ZStack {
                    ScrollViewReader { reader in
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 2) {
                                Spacer()
                                    .frame(width: UIScreen.main.bounds.width / 2)
                                
                                ForEach(volumeArr) { value in
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(width: 1, height: CGFloat(value.data))
                                        .foregroundColor(Color(asset: Asset.Colors.colorGreen69BE15))
                                        .id(value.id)
                                }
                            }
                        }
                        .onChange(of: volumeArr.count) { newValue in
                            reader.scrollTo(volumeArr.last?.id)
                        }
                        .onReceive(timer, perform: {_ in
                            if audioPlayer?.isPlaying ?? false {
                                isPlaying = true
                                if !volumeArr.isEmpty, volumeArr[arrIndex] != volumeArr.last {
                                    reader.scrollTo(volumeArr[arrIndex].id, anchor: .trailing)
                                    arrIndex += 1
                                }
                            } else {
                                isPlaying = false
                            }
                        })
                    }
                }
                .frame(height: 150)
                .padding(.top, 76.5)
                
                Spacer()
                
                if !doneRecording {
                    Button {
                        if !isRecording {
                            do {
                                let url = RingtoneExtractor.getRecordingPath()
                                
                                let fileName = url.appendingPathComponent("myRcd.m4a")
                                
                                RingtoneExtractor.shared.removeFileIfExists(fileURL: fileName.path) {
                                    print("Can't remove file at \(fileName)")
                                    return
                                }
                                
                                let settings = [
                                    AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                                    AVSampleRateKey: 12000,
                                    AVNumberOfChannelsKey: 1,
                                    AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
                                ]
                                
                                recorder = try AVAudioRecorder(url: fileName, settings: settings)
                                recorder.isMeteringEnabled = true
                                recorder.record()
                                
                                isRecording = true
                            } catch (let error) {
                                print("Record failed \(error)")
                            }
                        } else {
                            recorder.stop()
                            
                            isRecording = false
                            doneRecording = true
                        }
                    } label: {
                        Image(asset: isRecording ? Asset.Assets.icStopRecord : Asset.Assets.icStartRecord)
                    }
                } else {
                    HStack {
                        NoFillButtonView(text: L10n.delete, width: 100, height: 46, cornerRadius: 23, textSize: 14, color: Asset.Colors.colorGray83868A, lineWidth: 2) {
                            doneRecording = false
                            isRecording = false
                            arrIndex = 0
                            volumeArr.removeAll()
                        }
                        
                        Spacer()
                        
                        Button {
                            isPlaying ? pauseRecord() : playRecord()
                        } label: {
                            Image(asset: isPlaying ? Asset.Assets.icPauseRecord : Asset.Assets.icPlayRecord)
                        }
                        
                        Spacer()
                        
                        NoFillButtonView(text: L10n.continue, width: 100, height: 46, cornerRadius: 23, textSize: 14, color: Asset.Colors.colorGreen69BE15, lineWidth: 2) {
                            goToAudioCutter = true
                        }
                    }
                    .padding(.horizontal, 16)
                }
                
                
                Text(!isRecording && !doneRecording ? L10n.tapToRecord : "")
                    .modifier(TextModifier(color: Asset.Colors.colorGray83868A, size: 14, weight: .regular))
                    .padding(.top, 19)
                    .padding(.bottom, 45)
            }
            .frame(maxWidth: .infinity)
            
            if goToAudioCutter {
                let url = RingtoneExtractor.getRecordingPath()
                let fileName = url.appendingPathComponent("myRcd.m4a")
                
                NavigationLink(destination: AudioCutterView(url: fileName, isCreatedTmp: false, fromMyTone: false), isActive: $goToAudioCutter) {
                    EmptyView()
                }
            }
        }
        .navigationBarHidden(true)
        .onChange(of: doneRecording) { newValue in
            if newValue {
                session = AVAudioSession.sharedInstance()
                try? session.setCategory(.playback)
            } else {
                session = AVAudioSession.sharedInstance()
                try? session.setCategory(.playAndRecord)
            }
        }
        .onDisappear() {
            pauseRecord()
            try? AVAudioSession.sharedInstance().setCategory(.playback)
        }
        .onAppear() {
            try? AVAudioSession.sharedInstance().setCategory(.playAndRecord)
        }
        .onReceive(timer, perform: {_ in
            if isRecording {
                recorder.updateMeters()
                
                currentTime = recorder.currentTime
                
                startAnimation()
            }
        })
    }
    
    func convertdBFStodB(dBFS: Float) -> Float {
        var level: Float = 0.0
        let peakBottom: Float = -80.0
        
        if dBFS < peakBottom {
            level = 0.0
        } else if dBFS >= 0.0 {
            level = 1.0
        } else {
            let root: Float = 2.0
            let minAmp: Float = powf(10.0, 0.05 * peakBottom)
            let inverseAmpRange: Float = 1.0 / (1.0 - minAmp)
            let amp: Float = powf(10.0, 0.05 * dBFS)
            let adjAmp: Float = (amp - minAmp) * inverseAmpRange
            
            level = powf(adjAmp, 1.0 / root)
        }
        
        return level
    }
    
    func startAnimation() {
        if isRecording {
            let decibels = recorder.averagePower(forChannel: 0)
            let value = convertdBFStodB(dBFS: decibels) / 0.8 * 150
            var calibratedValue = value
            if value <= 10 {
                calibratedValue = 1
            } else if value < 150 {
                calibratedValue = value - 10
            } else if value >= 150 {
                calibratedValue = 150
            }
            print("Value 2", calibratedValue)
            volumeArr.append(FloatData(data: calibratedValue))
        }
    }
    
    func getAudio() {
        do {
            let url = RingtoneExtractor.getRecordingPath()
            
            let result = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
            
            print(result)
        } catch (let error) {
            print(error)
        }
    }
    
    func playRecord() {
        let url = RingtoneExtractor.getRecordingPath()
        
        let fileName = url.appendingPathComponent("myRcd.m4a")
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: fileName)
        } catch (let error) {
            print(error)
            return
        }
        
        arrIndex = 0
        audioPlayer?.currentTime = 0
        audioPlayer?.play()
    }
    
    func pauseRecord() {
        audioPlayer?.pause()
    }
}

struct RecordAudioView_Previews: PreviewProvider {
    static var previews: some View {
        RecordAudioView()
    }
}


