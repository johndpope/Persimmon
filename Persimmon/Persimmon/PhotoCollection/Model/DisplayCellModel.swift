//
//  CellModel.swift
//  Persimmon
//
//  Created by hyeoktae kwon on 2019/11/02.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import Photos
import AVKit
import ImageIO

class DisplayCellModel {
  private let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
  
  var cellType: String?
  var imageName: String?
  var videoName: String?
  var photoUUID: String?
  
  init(type: String, image: String, video: String, uuid: String) {
    self.cellType = type
    self.imageName = image
    self.videoName = video
    self.photoUUID = uuid
  }
  
  func getThumbnail(completion: @escaping (UIImage?) -> ()) {
    DispatchQueue.global(qos: .userInitiated).async {
      guard let uuid = self.photoUUID, let imageData = try? Data(contentsOf: self.url.appendingPathComponent("\(uuid)/small.jpg")) else { return }
      print("in getThumbnail: ", imageData)
      completion(UIImage(data: imageData))
    }
    
  }
  
//  func getThumbnail(completion: @escaping (UIImage?) -> ()) {
//
//    DispatchQueue.global(qos: .userInitiated).async {
//      guard let image = self.getImage() else { return }
//      let transform = CGAffineTransform(scaleX: 1, y: 1)
//      let size = image.size.applying(transform)
//      UIGraphicsBeginImageContext(size)
//      image.draw(in: CGRect(origin: .zero, size: size))
//      let resultImage = UIGraphicsGetImageFromCurrentImageContext()
//      UIGraphicsEndImageContext()
//
//      completion(resultImage)
//    }
//
//  }
  
  func getImage() -> UIImage? {
    guard let uuid = photoUUID, let name = imageName, let imageData = try? Data(contentsOf: url.appendingPathComponent("\(uuid)/\(name)")) else { return nil }
    
   return UIImage(data: imageData)
  }
  
  func getVideo() -> AVPlayer? {
    guard let uuid = photoUUID, let name = videoName else { return nil }
    let videoURL = url.appendingPathComponent("\(uuid)/\(name)")
    return AVPlayer(url: videoURL)
  }
  
  @discardableResult
  func getLivePhoto(completion: @escaping (PHLivePhoto?) -> ()) -> PHLivePhotoRequestID? {
    guard let uuid = photoUUID, let img = imageName, let video = videoName else {
      completion(nil)
      return nil }
    let videoURL = url.appendingPathComponent("\(uuid)/\(video)")
    let imageURL = url.appendingPathComponent("\(uuid)/\(img)")
    
    return PHLivePhoto.request(withResourceFileURLs: [videoURL, imageURL], placeholderImage: nil, targetSize: .zero, contentMode: .aspectFit) { (livePhoto, info) in
      if let isDegraded = info[PHLivePhotoInfoIsDegradedKey] as? Bool, isDegraded {
        return
      }
        completion(livePhoto)
    }
  }
  
  func saveToLibrary(completion: @escaping (Bool) -> Void) {
    
    PHPhotoLibrary.shared().performChanges({
      let creationRequest = PHAssetCreationRequest.forAsset()
      let options = PHAssetResourceCreationOptions()
      switch self.cellType {
      case "live":
        guard let uuid = self.photoUUID, let img = self.imageName, let video = self.videoName else { return }
        let videoURL = self.url.appendingPathComponent("\(uuid)/\(video)")
        let imageURL = self.url.appendingPathComponent("\(uuid)/\(img)")
        creationRequest.addResource(with: PHAssetResourceType.pairedVideo, fileURL: videoURL, options: options)
        creationRequest.addResource(with: PHAssetResourceType.photo, fileURL: imageURL, options: options)
      case "video":
        guard let uuid = self.photoUUID, let name = self.videoName else { return }
        let videoURL = self.url.appendingPathComponent("\(uuid)/\(name)")
        creationRequest.addResource(with: PHAssetResourceType.video, fileURL: videoURL, options: options)
      case "image":
        guard let uuid = self.photoUUID, let name = self.imageName else { return }
        let imageURL = self.url.appendingPathComponent("\(uuid)/\(name)")
        creationRequest.addResource(with: PHAssetResourceType.photo, fileURL: imageURL, options: options)
      default:
        break
      }
    }, completionHandler: { (success, error) in
      if error != nil {
        print(error as Any)
      }
      completion(success)
    })
  }
  
}

