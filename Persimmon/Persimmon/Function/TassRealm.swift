//
//  TassRealm.swift
//  Persimmon
//
//  Created by hyeoktae kwon on 2019/10/18.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import Foundation
import RealmSwift
import Photos
import TLPhotoPicker


final class RealmSingleton {
  static let shared = RealmSingleton()
  
  let realm: Realm = try! Realm()
  
  var thumbnailSize: CGSize = CGSize(width: 160, height: 160)
  
  private init() {}
  
  // realm init
   
  
  // realm object, rx기반이라 반응형, 쓰기 및 삭제 하면 바로 적용
  lazy var albums = realm.objects(Album.self)
  
  var selectAlbum: Album?
  
  // 이미지 익스포트를 위함
  lazy var imageManager: PHCachingImageManager = {
      return PHCachingImageManager()
  }()
  
  // add new album
  func addAlbum(title: String?) {
    try! realm.write {
      let newAlbum = Album()
      newAlbum.title = title == "" ? "새 앨범" : title ?? "새 앨범"
      realm.add(newAlbum, update: .modified)
    }
  }
  
  func takeSelectAlbum(uuid: String, selectRealm: Realm?) -> Album? {
    guard let selectRealm = selectRealm else {
      return realm.object(ofType: Album.self, forPrimaryKey: uuid)
    }
    return selectRealm.object(ofType: Album.self, forPrimaryKey: uuid)
  }
  
  func writeToRealm(albumUUID: String, photoUUID: String, localName: (String?, String?, String), completion: @escaping () -> ()) {
//    DispatchQueue(label: "realm", qos: .background).async {
//      autoreleasepool {
        let otherRealm = try! Realm()
        otherRealm.beginWrite()
        self.selectAlbum = self.takeSelectAlbum(uuid: albumUUID, selectRealm: otherRealm)
        
        guard let object = self.selectAlbum else { return }
        let photo = Photo()
        var type: String
        photo.uuid = photoUUID
        
        if localName.0 != nil, localName.1 == nil {
          type = "image"
          photo.imageName = localName.0!
        } else if localName.0 == nil, localName.1 != nil {
          type = "video"
          photo.videoName = localName.1!
        } else if localName.0 != nil, localName.1 != nil {
          type = "live"
          photo.videoName = localName.1!
          photo.imageName = localName.0!
        } else {
          dump("Error to Save Photo")
          return
        }
        
        photo.type = type
        photo.thumbnail = localName.2
        object.photos.append(photo)
        otherRealm.add(object, update: .modified)
        do {
          try otherRealm.commitWrite()
          completion()
        } catch(let err) {
          dump(err)
          completion()
        }
        
//      }
//    }
  }
  
  // Data -> realm write
  func writeWithLivePhoto(albumUUID: String, asset: TLPHAsset, livePhoto: PHLivePhoto) {
    
    selectAlbum = takeSelectAlbum(uuid: albumUUID, selectRealm: realm)
        _ = asset.fullResolutionImage?.jpegData(compressionQuality: 0.3)
    try! realm.write {
      guard let object = selectAlbum else { return }
      let photo = Photo()
//      photo.livePhoto = livePhoto
//      photo.asset = asset
//      photo.photoData = data
      object.photos.append(photo)
      realm.add(object, update: .modified)
    }
  }
  
  // Data -> realm write
    func writeWithPhoto(albumUUID: String, asset: TLPHAsset) {
      
      
      DispatchQueue(label: "realm", qos: .background).async {
        autoreleasepool {
          
          let otherRealm = try! Realm()
          otherRealm.beginWrite()
          
          let selectAlbum = self.takeSelectAlbum(uuid: albumUUID, selectRealm: otherRealm)
          
          _ = asset.fullResolutionImage?.jpegData(compressionQuality: 0.3)
          
            guard let object = selectAlbum else { return }
            let photo = Photo()
//            photo.photoData = data
            object.photos.append(photo)
            otherRealm.add(object, update: .modified)
          try! otherRealm.commitWrite()
        }
      }
      
    }
  
}
