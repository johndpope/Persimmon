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
  
  
  
  @discardableResult
  //convertLivePhotosToJPG
  // false : If you want mov file at live photos
  // true  : If you want png file at live photos ( HEIC )
  func saveMediaFile(asset: PHAsset?, uuid: String, convertLivePhotosToJPG: Bool = false, progressBlock:((Double) -> Void)? = nil, completionBlock:@escaping ((URL,String) -> Void)) -> PHImageRequestID? {
    guard let phAsset = asset else { return nil }
    var type: PHAssetResourceType? = nil
    if phAsset.mediaSubtypes.contains(.photoLive) == true, convertLivePhotosToJPG == false {
      type = .pairedVideo
    }else {
      type = phAsset.mediaType == .video ? .video : .photo
    }
    
//    PHAssetResource.assetResources(for: phAsset).forEach { (resource) in
//      print("result type: ", resource.type.rawValue)
//      print("result name: ", resource.originalFilename)
//    }
    
    guard let resource = (PHAssetResource.assetResources(for: phAsset).filter{ $0.type == type }).first else { return nil }
    let fileName = resource.originalFilename
    print("result name: ", fileName)
    var writeURL: URL? = nil
    
    let url = FileManager.default.urls(for: .developerDirectory, in: .userDomainMask).first
    
      writeURL = url?.appendingPathComponent("\(uuid)/\(fileName)")
    
    if (writeURL?.pathExtension.uppercased() == "HEIC" || writeURL?.pathExtension.uppercased() == "HEIF") && convertLivePhotosToJPG {
      if let fileName2 = writeURL?.deletingPathExtension().lastPathComponent {
        writeURL?.deleteLastPathComponent()
        writeURL?.appendPathComponent("\(fileName2).jpg")
      }
    }
    guard let localURL = writeURL,let mimetype = MIMEType(writeURL) else { return nil }
    
    switch phAsset.mediaType {
    case .video:
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
      
      return PHImageManager.default().requestExportSession(forVideo: phAsset, options: requestOptions, exportPreset: AVAssetExportPresetHighestQuality) { (session, infoDict) in
        session?.outputURL = localURL
        session?.outputFileType = AVFileType.mov
        session?.exportAsynchronously(completionHandler: {
          DispatchQueue.main.async {
            completionBlock(localURL, mimetype)
          }
        })
      }
    case .image:
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
      return PHImageManager.default().requestImageData(for: phAsset, options: requestOptions, resultHandler: { (data, uti, orientation, info) in
        do {
          var data = data
          let needConvertLivePhotoToJPG = phAsset.mediaSubtypes.contains(.photoLive) == true && convertLivePhotosToJPG == true
          if needConvertLivePhotoToJPG, let imgData = data, let rawImage = UIImage(data: imgData)?.upOrientationImage() {
            data = rawImage.jpegData(compressionQuality: 1)
          }
          
          try data?.write(to: localURL, options: .withoutOverwriting)
          DispatchQueue.main.async {
            completionBlock(localURL, mimetype)
          }
          
        }catch(let err) {
          print("error: ", localURL)
          dump(err)
        }
      })
    default:
      return nil
    }
  }
  
}
