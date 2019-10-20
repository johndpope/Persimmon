//
//  Photo.swift
//  Persimmon
//
//  Created by hyeoktae kwon on 2019/10/18.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import Photos
import MobileCoreServices


class TassPhoto {
  
  let fileManager = FileManager.default
  
  private func MIMEType(_ url: URL?) -> String? {
    guard let ext = url?.pathExtension else { return nil }
    if !ext.isEmpty {
      let UTIRef = UTTypeCreatePreferredIdentifierForTag("public.filename-extension" as CFString, ext as CFString, nil)
      let UTI = UTIRef?.takeUnretainedValue()
      UTIRef?.release()
      if let UTI = UTI {
        guard let MIMETypeRef = UTTypeCopyPreferredTagWithClass(UTI, kUTTagClassMIMEType) else { return nil }
        let MIMEType = MIMETypeRef.takeUnretainedValue()
        MIMETypeRef.release()
        return MIMEType as String
      }
    }
    return nil
  }
  
  
  
  func saveMediaFile(asset: PHAsset?, uuid: String, progressBlock:((Double) -> Void)? = nil, completionBlock:@escaping ((String?, String?) -> Void)) {
    guard let phAsset = asset else { return }
    
    let resource = PHAssetResource.assetResources(for: phAsset)
    
    var writeURL: URL? = nil
    
    let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
    
    writeURL = url?.appendingPathComponent(uuid)
    
    try? fileManager.createDirectory(at: writeURL!, withIntermediateDirectories: true, attributes: nil)
    
    saveResource(resource: resource, saveURL: writeURL, progressBlock: progressBlock) { (imageURL, videoURL) in
      completionBlock(imageURL, videoURL)
    }
    
  }
  
  private func saveResource(resource: [PHAssetResource], saveURL: URL?, progressBlock:((Double) -> Void)? = nil, completion: @escaping ((String?, String?) -> Void) ) {
    
    let option = PHAssetResourceRequestOptions()
    option.isNetworkAccessAllowed = true
    option.progressHandler = {(double) in
      progressBlock?(double)
    }
    
    let saveURL = saveURL
    var videoURL: URL?
    var imageURL: URL?
    var videoName: String?
    var imageName: String?
    
    resource.forEach {
      switch $0.type {
      case .pairedVideo, .adjustmentBasePairedVideo, .adjustmentBaseVideo, .fullSizePairedVideo, .video, .fullSizeVideo:
        videoName = $0.originalFilename
        videoURL = saveURL?.appendingPathComponent(videoName!)
        PHAssetResourceManager.default().writeData(for: $0, toFile: videoURL!, options: option) { (err) in
          guard let err = err else { return }
          videoName = nil
          dump(err)
        }
      default:
        imageName = $0.originalFilename
        imageURL = saveURL?.appendingPathComponent(imageName!)
        PHAssetResourceManager.default().writeData(for: $0, toFile: imageURL!, options: option) { (err) in
          guard let err = err else { return }
          imageName = nil
          dump(err)
        }
      }
    }
    
    if imageName == nil, videoName != nil {
      do {
        imageURL = saveURL?.appendingPathComponent("thumbnail.png")
        imageName = "thumbnail.png"
        try generateThumbnail(path: videoURL!)?.write(to: imageURL!, options: .withoutOverwriting)
      }catch(let err) {
        dump(err)
      }
    }
    
    completion(imageName, videoName)
    
  }
  
  private func generateThumbnail(path: URL) -> Data? {
      do {
          let asset = AVURLAsset(url: path, options: nil)
          let imgGenerator = AVAssetImageGenerator(asset: asset)
          imgGenerator.appliesPreferredTrackTransform = true
          let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
          let thumbnail = UIImage(cgImage: cgImage)
        return thumbnail.pngData()
      } catch let error {
          print("*** Error generating thumbnail: \(error.localizedDescription)")
          return nil
      }
  }
  
  
  private func saveImage(asset: PHAsset, saveURL: URL?, progressBlock:((Double) -> Void)? = nil, completion: @escaping ((URL, String) -> Void)) -> PHImageRequestID? {
    guard let mimetype = MIMEType(saveURL), let saveURL = saveURL else { return nil }
    
    let requestOptions = PHImageRequestOptions()
    requestOptions.isNetworkAccessAllowed = true
    requestOptions.deliveryMode = .highQualityFormat
    requestOptions.isSynchronous = false
    requestOptions.resizeMode = .none
    requestOptions.version = .original
    
    //iCloud download progress
    requestOptions.progressHandler = { (progress, error, stop, info) in
      DispatchQueue.main.async {
        progressBlock?(progress)
      }
    }
    
    return PHImageManager.default().requestImageData(for: asset, options: requestOptions, resultHandler: { (data, uti, orientation, info) in
      do {
        try data?.write(to: saveURL, options: .withoutOverwriting)
        DispatchQueue.main.async {
          completion(saveURL, mimetype)
        }
      }catch(let err) {
        dump(err)
      }
    })
  }
  
  private func saveVideo(asset: PHAsset, saveURL: URL?, progressBlock:((Double) -> Void)? = nil, completion: @escaping ((URL, String) -> Void)) -> PHImageRequestID? {
    guard let mimetype = MIMEType(saveURL), let saveURL = saveURL else { return nil }
    
    let requestOptions = PHVideoRequestOptions()
    requestOptions.deliveryMode = .highQualityFormat
    requestOptions.isNetworkAccessAllowed = true
    requestOptions.version = .current
    
    //iCloud download progress
    requestOptions.progressHandler = { (progress, error, stop, info) in
      DispatchQueue.main.async {
        progressBlock?(progress)
      }
    }
    
    return PHImageManager.default().requestExportSession(forVideo: asset, options: requestOptions, exportPreset: AVAssetExportPresetHighestQuality) { (session, infoDict) in
      session?.outputURL = saveURL
      session?.outputFileType = AVFileType.mov
      session?.exportAsynchronously(completionHandler: {
        DispatchQueue.main.async {
          completion(saveURL, mimetype)
        }
      })
    }
  }
  
}
