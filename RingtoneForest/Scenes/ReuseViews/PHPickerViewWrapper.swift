//
//  PHPickerViewWrapper.swift
//  RingtoneForest
//
//  Created by Thu Truong on 11/3/23.
//

import Foundation
import PhotosUI
import SwiftUI

struct PHPickerViewWrapper: UIViewControllerRepresentable {
    @Binding var showLoading: Bool
    var isAudio: Bool
    var finishPickingVideo: (URL?, PHAsset?) -> Void
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        config.selectionLimit = 1
        config.filter = .videos
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> PHPickerCoordinator {
        PHPickerCoordinator(self, isAudio: isAudio, finishPickingVideo: finishPickingVideo)
    }
}

class PHPickerCoordinator: NSObject, PHPickerViewControllerDelegate {
    let parent: PHPickerViewWrapper
    
    var finishPickingVideo: (URL?, PHAsset?) -> Void
    var isAudio: Bool
    
    init(_ parent: PHPickerViewWrapper, isAudio: Bool, finishPickingVideo: @escaping (URL?, PHAsset?) -> Void) {
        self.parent = parent
        self.isAudio = isAudio
        self.finishPickingVideo = finishPickingVideo
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        parent.showLoading = true
        
        if !results.isEmpty {
            let provider = results.first!.itemProvider
            if isAudio {
                provider.loadFileRepresentation(forTypeIdentifier: "public.movie") { [weak self] url, error in
                    guard let url = url else {
                        picker.dismiss(animated: true)
                        return
                    }
                    self?.finishPickingVideo(url, nil)
                    DispatchQueue.main.async {
                        picker.dismiss(animated: true)
                    }
                }
            } else {
                let identifiers: [String] = results.compactMap(\.assetIdentifier)
                let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: nil)
                guard let asset = fetchResult.firstObject else {
                    picker.dismiss(animated: true)
                    return
                }
                
                DispatchQueue.main.async {
                    picker.dismiss(animated: true)
                    self.finishPickingVideo(nil, asset)
                }
            }
            
            
        } else {
            parent.showLoading = false
            picker.dismiss(animated: true)
        }
    }
}
