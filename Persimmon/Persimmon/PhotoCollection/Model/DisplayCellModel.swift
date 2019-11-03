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
  
  func getImage() -> UIImage? {
    guard let uuid = photoUUID, let name = imageName, let imageData = try? Data(contentsOf: url.appendingPathComponent("\(uuid)/\(name)")) else { return nil }
   return UIImage(data: imageData)
  }
  
  func getVideo() -> AVPlayer? {
    guard let uuid = photoUUID, let name = videoName else { return nil }
    let videoURL = url.appendingPathComponent("\(uuid)/\(name)")
    return AVPlayer(url: videoURL)
  }
  
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
  
}

