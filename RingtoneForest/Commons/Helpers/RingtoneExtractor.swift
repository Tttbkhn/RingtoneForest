//
//  RingtoneExtractor.swift
//  RingtoneForest
//
//  Created by Thu Truong on 8/23/23.
//

import Foundation
import AVFoundation

class RingtoneExtractor {
    static let shared = RingtoneExtractor()
    
    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    static func getRingtonePath() -> URL {
        let ringtonePath = getDocumentsDirectory().appendingPathComponent("Ringtones")
        
        if !FileManager.default.fileExists(atPath: ringtonePath.path) {
            do {
                try FileManager.default.createDirectory(atPath: ringtonePath.path, withIntermediateDirectories: true, attributes: nil)
                return ringtonePath
            } catch {
                print("create directory failed at \(ringtonePath)")
            }
        }
        
        return ringtonePath
    }
    
    static func getRecordingPath() -> URL {
        let recordingPath = getDocumentsDirectory().appendingPathComponent("Recordings")
        
        if !FileManager.default.fileExists(atPath: recordingPath.path) {
            do {
                try FileManager.default.createDirectory(atPath: recordingPath.path, withIntermediateDirectories: true, attributes: nil)
                return recordingPath
            } catch {
                print("create directory failed at \(recordingPath)")
            }
        }
        
        return recordingPath
    }
    
    func trimAudio(asset: AVAsset, outputFileName: String, startTime: Double, stopTime: Double, fadeIn: Bool, fadeOut: Bool, finished: @escaping (AVAssetExportSession.Status) -> ()) async {
        guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A) else { return }
        let url = RingtoneExtractor.getRingtonePath().appendingPathComponent("\(outputFileName).m4a")
        
        exportSession.outputURL = url
        exportSession.outputFileType = AVFileType.m4a
        
        removeFileIfExists(fileURL: url.path)
        
        do {
            let timescale: CMTimeScale!
            if #available(iOS 15, *) {
                timescale = try await asset.load(.duration).timescale
            } else {
                timescale = asset.duration.timescale
            }
            let start: CMTime = CMTimeMakeWithSeconds(startTime, preferredTimescale: timescale)
            let end: CMTime = CMTimeMakeWithSeconds(stopTime, preferredTimescale: timescale)
            let range = CMTimeRangeFromTimeToTime(start: start, end: end)
            exportSession.timeRange = range
            
            if (fadeIn || fadeOut) {
                let exportAudioMix = AVMutableAudioMix()
                let exportAudioMixInputParameters: AVMutableAudioMixInputParameters!
                if #available(iOS 15, *) {
                    exportAudioMixInputParameters = try await AVMutableAudioMixInputParameters(track: asset.loadTracks(withMediaType: AVMediaType.audio).first)
                } else {
                    exportAudioMixInputParameters = AVMutableAudioMixInputParameters(track: asset.tracks(withMediaType: AVMediaType.audio).first)
                }
                
                if (fadeIn) {
                    for i in stride(from: 0, to: 2, by: 0.2) {
                        exportAudioMixInputParameters.setVolume(Float(i / 2), at: CMTimeMakeWithSeconds(startTime + i, preferredTimescale: timescale))
                    }
                }
                
                if fadeOut {
                    for i in stride(from: 2, to: -0.1, by: -0.2) {
                        exportAudioMixInputParameters.setVolume(Float(i / 2), at: CMTimeMakeWithSeconds(stopTime - i, preferredTimescale: timescale))
                    }
                }
                
                exportAudioMix.inputParameters = [exportAudioMixInputParameters]
                exportSession.audioMix = exportAudioMix
            }
            
            await exportSession.export()
            
            switch exportSession.status {
            case .failed:
                print("Export failed \(String(describing: exportSession.error))")
                finished(exportSession.status)
            case .cancelled:
                print("Export cancelled")
            case .completed:
                print("Export success")
                ToneCacheCD.shared.addNewTone(tone: MyTone(name: outputFileName, fileName: url.path, duration: stopTime - startTime))
                finished(exportSession.status)
            default:
                break
            }
        } catch (let error) {
            print(error)
        }
    }
    
    func removeFileIfExists(fileURL: String, _ completion: (() -> ())? = nil) {
        if FileManager.default.fileExists(atPath: fileURL) {
            print("Ringtone exists, remove \(fileURL)")
            
            do {
                try FileManager.default.removeItem(atPath: fileURL)
            } catch (let error) {
                print("Can't remove file at \(fileURL) \(error)")
                if let completion = completion {
                    completion()
                }
            }
        }
    }
}
