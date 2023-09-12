//
//  GarageBandConverter.swift
//  RingtoneForest
//
//  Created by Thu Truong on 9/12/23.
//

import Foundation
import AVFoundation

class GarageBandConverter {
    static func share(url: URL, name: String, completion: @escaping (URL?, String?) -> Void) {
        let audioFileInput = url
        let mixedAudio: String = "ringtone.aiff"
        let exportPathDirectory = NSTemporaryDirectory()
        let projectBandDirectory = exportPathDirectory + "\(name).band"
        if (FileManager.default.fileExists(atPath: projectBandDirectory)) {
            try! FileManager.default.removeItem(at: URL(fileURLWithPath: projectBandDirectory))
        }
        
        try! FileManager.default.createDirectory(atPath: projectBandDirectory, withIntermediateDirectories: true, attributes: nil)
        
        
        let exportPath: String = projectBandDirectory + "/"
        let bundlePath = Bundle.main.path(forResource: "projectData", ofType: "")
        let fullDestPath = NSURL(fileURLWithPath: exportPath).appendingPathComponent("projectData")
        let fullDestPathString = (fullDestPath?.path)!
        
        try! FileManager.default.createDirectory(atPath: exportPath + "Media", withIntermediateDirectories: true, attributes: nil)
        try! FileManager.default.createDirectory(atPath: exportPath + "Output", withIntermediateDirectories: true, attributes: nil)
        
        let audioFileOutput = URL(fileURLWithPath: exportPathDirectory + mixedAudio)
        print("Will export \(audioFileInput.absoluteString)")
        
        try? FileManager.default.removeItem(at: audioFileOutput)
        
        let asset = AVAsset(url: audioFileInput)
        let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetPassthrough)
        
        if (exportSession == nil) {
            completion(nil, "ExportSession is nil")
            return
        }
        
        exportSession!.outputURL = audioFileOutput
        exportSession!.outputFileType = AVFileType.caf
        
        exportSession!.exportAsynchronously {
            switch (exportSession!.status) {
            case .completed:
                guard let url = exportSession!.outputURL else { return }
                
                let destUrl = URL(fileURLWithPath: exportPath + "Media/ringtone.aiff")
                
                do {
                    try FileManager.default.copyItem(atPath: bundlePath!, toPath: fullDestPathString)
                    try FileManager.default.copyItem(atPath: url.path, toPath: destUrl.path)
                    completion(URL(fileURLWithPath: exportPath), nil)
                } catch let error {
                    completion(nil, error.localizedDescription)
                }
                break
            default:
                completion(nil, exportSession!.error?.localizedDescription)
                break
            }
        }
    }
}
