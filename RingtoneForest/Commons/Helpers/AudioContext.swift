//
//  AudioContext.swift
//  RingtoneForest
//
//  Created by Thu Trương on 30/07/2023.
//

import Foundation
import AVFoundation
import Accelerate

/// Holds audio information used for building waveforms
final class AudioContext {
    
    /// The audio asset URL used to load the context
    public let audioURL: URL
    
    /// Total number of samples in loaded asset
    public let totalSamples: Int
    
    /// Loaded asset
    public let asset: AVAsset
    
    // Loaded assetTrack
    public let assetTrack: AVAssetTrack
    
    public let duration: CMTime
    
    public let formatDescriptions: [CMAudioFormatDescription]
    
    private init(audioURL: URL, totalSamples: Int, asset: AVAsset, assetTrack: AVAssetTrack, duration: CMTime, formatDescriptions: [CMAudioFormatDescription]) {
        self.audioURL = audioURL
        self.totalSamples = totalSamples
        self.asset = asset
        self.assetTrack = assetTrack
        self.duration = duration
        self.formatDescriptions = formatDescriptions
    }
    
    public static func load(fromAudioURL audioURL: URL, completionHandler: @escaping (_ audioContext: AudioContext?) -> ()) async throws {
        let asset = AVURLAsset(url: audioURL, options: [AVURLAssetPreferPreciseDurationAndTimingKey: NSNumber(value: true as Bool)])
        
        var assetTrack: AVAssetTrack? = nil
        
        if #available(iOS 15.0, *) {
            asset.loadTracks(withMediaType: AVMediaType.audio) { assetTracks, error in
                guard error == nil else {
                    print("Couldn't load AVAssetTrack")
                    return
                }
                
                assetTrack = assetTracks?.first
                
                Task {
                    _ = try await asset.load(.duration)
                    switch asset.status(of: .duration) {
                    case .notYetLoaded:
                        completionHandler(nil)
                        break
                    case .loading:
                        completionHandler(nil)
                        break
                    case .loaded(let duration):
                        guard let assetTrack = assetTrack else { break }
                        let formatDescriptions = try await assetTrack.load(.formatDescriptions)
                        guard let audioFormatDesc = formatDescriptions.first, let asbd = CMAudioFormatDescriptionGetStreamBasicDescription(audioFormatDesc) else { break }
                        let totalSamples = Int((asbd.pointee.mSampleRate) * Float64(asset.duration.value) / Float64(asset.duration.timescale))
                        let audioContext = AudioContext(audioURL: audioURL, totalSamples: totalSamples, asset: asset, assetTrack: assetTrack, duration: duration, formatDescriptions: formatDescriptions)
                        completionHandler(audioContext)
                        return
                    case .failed(let error):
                        print("Couldn't load asset: \(error.localizedDescription)")
                        completionHandler(nil)
                    }
                }
            }
        } else {
            guard let assetTrack = asset.tracks(withMediaType: AVMediaType.audio).first else {
                print("failed to load AVAssetTrack")
                completionHandler(nil)
                return
            }
            
            asset.loadValuesAsynchronously(forKeys: ["duration"]) {
                var error: NSError?
                let status = asset.statusOfValue(forKey: "duration", error: &error)
                switch status {
                case .loaded:
                    guard
                        let formatDescriptions = assetTrack.formatDescriptions as? [CMAudioFormatDescription],
                        let audioFormatDesc = formatDescriptions.first,
                        let asbd = CMAudioFormatDescriptionGetStreamBasicDescription(audioFormatDesc)
                        else { break }
                    
                    let totalSamples = Int((asbd.pointee.mSampleRate) * Float64(asset.duration.value) / Float64(asset.duration.timescale))
                    let audioContext = AudioContext(audioURL: audioURL, totalSamples: totalSamples, asset: asset, assetTrack: assetTrack, duration: asset.duration, formatDescriptions: formatDescriptions)
                    completionHandler(audioContext)
                    return
                    
                case .failed, .cancelled, .loading, .unknown:
                    print("Couldn't load asset: \(error?.localizedDescription ?? "Unknown error")")
                @unknown default:
                    print("Couldn't load asset: \(error?.localizedDescription ?? "Unknown error")")
                }
                
                completionHandler(nil)
            }
        }
    }
}

let noiseFloor: Float = -80

func render(audioContext: AudioContext?, targetSamples: Int = 100) -> [Float] {
    guard let audioContext = audioContext else {
        fatalError("Couldn't create the audioContext")
    }
    
    let sampleRange: CountableRange<Int> = 0..<audioContext.totalSamples
    
    guard let reader = try? AVAssetReader(asset: audioContext.asset)
        else {
            fatalError("Couldn't initialize the AVAssetReader")
    }
    
    reader.timeRange = CMTimeRange(start: CMTime(value: Int64(sampleRange.lowerBound), timescale: audioContext.asset.duration.timescale),
                                   duration: CMTime(value: Int64(sampleRange.count), timescale: audioContext.asset.duration.timescale))
    
    let outputSettingsDict: [String : Any] = [
        AVFormatIDKey: Int(kAudioFormatLinearPCM),
        AVLinearPCMBitDepthKey: 16,
        AVLinearPCMIsBigEndianKey: false,
        AVLinearPCMIsFloatKey: false,
        AVLinearPCMIsNonInterleaved: false
    ]
    
    let readerOutput = AVAssetReaderTrackOutput(track: audioContext.assetTrack,
                                                outputSettings: outputSettingsDict)
    readerOutput.alwaysCopiesSampleData = false
    reader.add(readerOutput)
    
    var channelCount = 1
    let formatDescriptions = audioContext.assetTrack.formatDescriptions as! [CMAudioFormatDescription]
    for item in formatDescriptions {
        guard let fmtDesc = CMAudioFormatDescriptionGetStreamBasicDescription(item) else {
            fatalError("Couldn't get the format description")
        }
        channelCount = Int(fmtDesc.pointee.mChannelsPerFrame)
    }
    
    let samplesPerPixel = max(1, channelCount * sampleRange.count / targetSamples)
    let filter = [Float](repeating: 1.0 / Float(samplesPerPixel), count: samplesPerPixel)
    
    var outputSamples = [Float]()
    var sampleBuffer = Data()
    
    // 16-bit samples
    reader.startReading()
    defer { reader.cancelReading() }
    
    while reader.status == .reading {
        guard let readSampleBuffer = readerOutput.copyNextSampleBuffer(),
            let readBuffer = CMSampleBufferGetDataBuffer(readSampleBuffer) else {
                break
        }
        // Append audio sample buffer into our current sample buffer
        var readBufferLength = 0
        var readBufferPointer: UnsafeMutablePointer<Int8>?
        CMBlockBufferGetDataPointer(readBuffer,
                                    atOffset: 0,
                                    lengthAtOffsetOut: &readBufferLength,
                                    totalLengthOut: nil,
                                    dataPointerOut: &readBufferPointer)
        sampleBuffer.append(UnsafeBufferPointer(start: readBufferPointer, count: readBufferLength))
        CMSampleBufferInvalidate(readSampleBuffer)
        
        let totalSamples = sampleBuffer.count / MemoryLayout<Int16>.size
        let downSampledLength = totalSamples / samplesPerPixel
        let samplesToProcess = downSampledLength * samplesPerPixel
        
        guard samplesToProcess > 0 else { continue }
        
        processSamples(fromData: &sampleBuffer,
                       outputSamples: &outputSamples,
                       samplesToProcess: samplesToProcess,
                       downSampledLength: downSampledLength,
                       samplesPerPixel: samplesPerPixel,
                       filter: filter)
        //print("Status: \(reader.status)")
    }
    
    // Process the remaining samples at the end which didn't fit into samplesPerPixel
    let samplesToProcess = sampleBuffer.count / MemoryLayout<Int16>.size
    if samplesToProcess > 0 {
        let downSampledLength = 1
        let samplesPerPixel = samplesToProcess
        let filter = [Float](repeating: 1.0 / Float(samplesPerPixel), count: samplesPerPixel)
        
        processSamples(fromData: &sampleBuffer,
                       outputSamples: &outputSamples,
                       samplesToProcess: samplesToProcess,
                       downSampledLength: downSampledLength,
                       samplesPerPixel: samplesPerPixel,
                       filter: filter)
        //print("Status: \(reader.status)")
    }
    
    // if (reader.status == AVAssetReaderStatusFailed || reader.status == AVAssetReaderStatusUnknown)
    guard reader.status == .completed else {
        fatalError("Couldn't read the audio file")
    }
    
    return outputSamples
}

func processSamples(fromData sampleBuffer: inout Data,
                    outputSamples: inout [Float],
                    samplesToProcess: Int,
                    downSampledLength: Int,
                    samplesPerPixel: Int,
                    filter: [Float]) {
    
    sampleBuffer.withUnsafeBytes { (samples: UnsafeRawBufferPointer) in
        var processingBuffer = [Float](repeating: 0.0, count: samplesToProcess)
        
        let sampleCount = vDSP_Length(samplesToProcess)
        
        //Create an UnsafePointer<Int16> from samples
        let unsafeBufferPointer = samples.bindMemory(to: Int16.self)
        let unsafePointer = unsafeBufferPointer.baseAddress!
        
        //Convert 16bit int samples to floats
        vDSP_vflt16(unsafePointer, 1, &processingBuffer, 1, sampleCount)
        
        //Take the absolute values to get amplitude
        vDSP_vabs(processingBuffer, 1, &processingBuffer, 1, sampleCount)
        
        //get the corresponding dB, and clip the results
        getdB(from: &processingBuffer)
        
        //Downsample and average
        var downSampledData = [Float](repeating: 0.0, count: downSampledLength)
        vDSP_desamp(processingBuffer,
                    vDSP_Stride(samplesPerPixel),
                    filter, &downSampledData,
                    vDSP_Length(downSampledLength),
                    vDSP_Length(samplesPerPixel))
        
        //Remove processed samples
        sampleBuffer.removeFirst(samplesToProcess * MemoryLayout<Int16>.size)
        
        outputSamples += downSampledData
    }
}

func getdB(from normalizedSamples: inout [Float]) {
    // Convert samples to a log scale
    var zero: Float = 32768.0
    vDSP_vdbcon(normalizedSamples, 1, &zero, &normalizedSamples, 1, vDSP_Length(normalizedSamples.count), 1)
    
    //Clip to [noiseFloor, 0]
    var ceil: Float = 0.0
    var noiseFloorMutable = noiseFloor
    vDSP_vclip(normalizedSamples, 1, &noiseFloorMutable, &ceil, &normalizedSamples, 1, vDSP_Length(normalizedSamples.count))
}
