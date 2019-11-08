//
//  DisplayModel.swift
//  Persimmon
//
//  Created by hyeoktae kwon on 2019/11/02.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import Foundation
import Photos

class DisplayModel {
  var firstInit = true
  var object: Album?
  var selectedCell: IndexPath = []
  var albumUUID: String?
  var tempPhotos: [IndexPath:(Bool, TempPhoto?)] = [:] {
    didSet {
      print("selected: ", selectedCell)
      print("tempPhotos: ", tempPhotos.sorted(by: { (old, new) -> Bool in
        old.key.row < new.key.row
      }))
    }
  }
  var requestID: [PHLivePhotoRequestID?] = []
  var lastIndex: IndexPath = [] {
    willSet(new) {
      guard !firstInit else { return }
      compareIndex(old: lastIndex, new: new)
    }
  }
  
  init(uuid: String, indexPath: IndexPath) {
    self.albumUUID = uuid
    self.selectedCell = indexPath
//    self.lastIndex = indexPath
    self.object = RealmSingleton.shared.takeSelectAlbum(albumUUID: uuid)
    firstInit = false
  }
  
  func compareIndex(old: IndexPath, new: IndexPath) {
    if new.row - old.row > 0 {
      // 오른쪽으로 스와이프
      updateTempPhoto(state: true)
    } else if new.row - old.row < 0 {
      // 왼쪽으로 스와이프
      updateTempPhoto(state: false)
    }
  }
  
  func updateTempPhoto(state: Bool) {
    let keys = tempPhotos.keys.sorted()
    switch state {
    case true:
      guard let photoObject = object?.photos, let index = keys.last?.row, let first = keys.first else { return }
      guard (index + 1) < photoObject.count else { return }
      guard let photo = object?.photos[index + 1] else { return }
      let photoModel = DisplayCellModel(type: photo.type,
                                        image: photo.imageName,
                                        video: photo.videoName,
                                        uuid: photo.photoUUID)
      
      tempPhotos[IndexPath(row: index + 1, section: 0)] = (false, nil)
      
//      DispatchQueue.global(qos: .userInteractive).async {
        self.makePhoto(photoModel: photoModel) { (temp) in
          self.tempPhotos[IndexPath(row: index + 1, section: 0)] = (true, temp)
          self.tempPhotos.removeValue(forKey: first)
        }
//      }
    case false:
      guard let index = keys.first?.row, let last = keys.last else { return }
      guard (index - 1) > 0 else { return }
      guard let photo = object?.photos[index - 1] else { return }
      let photoModel = DisplayCellModel(type: photo.type,
                                        image: photo.imageName,
                                        video: photo.videoName,
                                        uuid: photo.photoUUID)
      
      tempPhotos[IndexPath(row: index - 1, section: 0)] = (false, nil)
      
//      DispatchQueue.global(qos: .userInteractive).async {
        self.makePhoto(photoModel: photoModel) { (temp) in
          self.tempPhotos[IndexPath(row: index + 1, section: 0)] = (true, temp)
          self.tempPhotos.removeValue(forKey: last)
        }
//      }
    }
  }
  
  func makePhoto(photoModel: DisplayCellModel, completion: @escaping (TempPhoto?) -> ()) {
    switch photoModel.cellType {
    case "live":
      self.requestID.append(photoModel.getLivePhoto { (live) in
        completion(live)
      })
    case "image":
      completion(photoModel.getImage())
    case "video":
      completion(photoModel.getVideo())
    default:
      break
    }
  }
  
  
  func prefetchTempPhotos(_ currentIndex: IndexPath? = nil) {
    makeIndexPathArr(currentIndex).forEach { index in
      makePhoto(index: index) { (temp) in
        self.tempPhotos[index] = (true, temp)
      }
    }
  }
  
  
  func asyncPrefetchTempPhotos(_ currentIndex: IndexPath? = nil) {
    makeIndexPathArr(currentIndex).forEach { index in
      guard let photo = object?.photos[index.row] else { return }
      let photoModel = DisplayCellModel(type: photo.type,
                                        image: photo.imageName,
                                        video: photo.videoName,
                                        uuid: photo.photoUUID)
      DispatchQueue.global(qos: .userInteractive).async {
        self.makePhoto(photoModel: photoModel) { (temp)  in
          self.tempPhotos[index] = (true, temp)
        }
      }
    }
  }
  
  func makePhoto(index: IndexPath, completion: @escaping (TempPhoto?) -> ()) {
    guard let photo = object?.photos[index.row] else { return }
    let photoModel = DisplayCellModel(type: photo.type,
                                      image: photo.imageName,
                                      video: photo.videoName,
                                      uuid: photo.photoUUID)
    
    switch photo.type {
    case "live":
      self.requestID.append(photoModel.getLivePhoto { (live) in
        completion(live)
      })
    case "image":
      completion(photoModel.getImage())
    case "video":
      completion(photoModel.getVideo())
    default:
      break
    }
  }
  
  func makeIndexPathArr(_ currentIndex: IndexPath?) -> [IndexPath] {
    let minMax = getMinMax(currentIndex)
    var indexPathArr: [IndexPath] = []
    for row in minMax.0 ... minMax.1 {
      indexPathArr.append(IndexPath(row: row, section: 0))
    }
    return indexPathArr
  }
  
  func getMinMax(_ currentIndex: IndexPath?) -> (Int, Int) {
    var row: Int = 0
    if let index = currentIndex {
      row = index.row
    } else {
      row = selectedCell.row
    }
    guard let maxCount = object?.photos.count else { return (0, 0) }
    var min = 0
    var max = 0
    for idx in row-5 ... row {
      if idx >= 0 {
        min = idx
        break
      }
    }
    for idx in (row...row+5).reversed() {
      if idx <= maxCount - 1 {
        max = idx
        break
      }
    }
    return (min, max)
  }
}
