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
  
  // realm 과 albumUUID를 통해 단 한개의 album object를 반환
  func takeSelectAlbum(albumUUID: String, selectRealm: Realm? = nil) -> Album? {
    guard let selectRealm = selectRealm else {
      return realm.object(ofType: Album.self, forPrimaryKey: albumUUID)
    }
    return selectRealm.object(ofType: Album.self, forPrimaryKey: albumUUID)
  }
  
  func changeAlbumTitle(title: String?, albumUUID: String) {
    let title = title == "" ? "구 앨범" : title ?? "구 앨범"
    let object = takeSelectAlbum(albumUUID: albumUUID)
    try! realm.write {
      object?.title = title
    }
  }
  
  func deleteAlbum(albumUUID: String) {
    guard let object = takeSelectAlbum(albumUUID: albumUUID) else { return }
    try! realm.write {
      realm.delete(object)
    }
  }
  
  func restorePhotos(arr: [Int], completion: () -> ()) {
    let grave = takeGrave()
    let reversedArr = arr.sorted().reversed()
    let newAlbum = Album()
    newAlbum.title = "복원된 사진"
    
    try! realm.write {
      reversedArr.forEach {
        let temp = grave.photos[$0]
        
        guard let object = takeSelectAlbum(albumUUID: temp.albumUUID) else {
          temp.albumUUID = newAlbum.albumUUID
          newAlbum.photos.append(temp)
          grave.photos.remove(at: $0)
          return }
        
        temp.albumUUID = object.albumUUID
        object.photos.append(temp)
        grave.photos.remove(at: $0)
      }
      guard newAlbum.photos.count > 0 else { return }
      realm.add(newAlbum, update: .modified)
    }
    completion()
    
  }
  
  func moveToOther(from: String, to: String? = nil, arr: [Int]) {
    guard let fromAlbum = takeSelectAlbum(albumUUID: from) else { return }
    let grave = takeGrave()
    let reversedArr = arr.sorted().reversed()
    
    try! realm.write {
      var tempPhoto = [Photo]()
      reversedArr.forEach {
        tempPhoto.append(fromAlbum.photos[$0])
        fromAlbum.photos.remove(at: $0)
      }
      if let to = to {
        guard let object = takeSelectAlbum(albumUUID: to) else { return }
        object.photos.append(objectsIn: tempPhoto)
      } else {
        grave.photos.append(objectsIn: tempPhoto)
      }
    }
    
  }
  
  // GravePhotos 오브젝트를 가져옴, Grave있으면 가져오고 없으면 만들어서 가져옴
  func takeGrave(selectRealm: Realm? = nil) -> Grave {
    let temp = selectRealm == nil ? realm : selectRealm
    guard let select = temp, let grave = select.object(ofType: Grave.self, forPrimaryKey: "Grave") else {
      let object = Grave()
      try! realm.write {
        realm.add(object, update: .all)
      }
      return realm.object(ofType: Grave.self, forPrimaryKey: "Grave")!
    }
    return grave
  }
  
  // 저장 후 이미지이름 비디오이름 포토UUID를 저장한다. 비동기!!!
  func writeData(albumUUID: String, localNames: [(String?, String?, String, String?)], completion: (Int) -> ()) {
    var failCount = 0
    var photos: [Photo] = []
    localNames.forEach { (localName) in
      let photo = Photo()
      photo.photoUUID = localName.2
      photo.albumUUID = albumUUID
      
      if localName.0 != nil, localName.1 == nil {
        photo.type = "image"
        photo.imageName = localName.0!
      } else if localName.0 == nil, localName.1 != nil {
        photo.type = "video"
        photo.duration = localName.3 ?? "0:0"
        photo.videoName = localName.1!
      } else if localName.0 != nil, localName.1 != nil {
        photo.type = "live"
        photo.videoName = localName.1!
        photo.imageName = localName.0!
      } else {
        dump("Error to Save Photo")
        failCount += 1
      }
      photos.append(photo)
    }
    
    // objective-c 객체가 swift 객체가 메모리에서 해제될때 같이 해제되도록 하는 autoreleasepool, 비동기처리시 필요
    autoreleasepool {
      do{
        let otherRealm = try! Realm()
        otherRealm.beginWrite()
        guard let object = takeSelectAlbum(albumUUID: albumUUID, selectRealm: otherRealm) else { return }
        object.photos.append(objectsIn: photos)
        otherRealm.add(object, update: .modified)
        try otherRealm.commitWrite()
        completion(failCount)
      } catch(let err) {
        dump(err)
        completion(9999)
      }
    }
    
    
  }
  
  func writeToRealm(albumUUID: String, photoUUID: String, localName: (String?, String?, String), completion: @escaping () -> ()) {
    //    DispatchQueue(label: "realm", qos: .background).async {
//      autoreleasepool {
        let otherRealm = try! Realm()
        otherRealm.beginWrite()
        self.selectAlbum = self.takeSelectAlbum(albumUUID: albumUUID, selectRealm: otherRealm)
        
        guard let object = self.selectAlbum else { return }
        let photo = Photo()
        var type: String
        photo.photoUUID = photoUUID
        
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
    
    selectAlbum = takeSelectAlbum(albumUUID: albumUUID, selectRealm: realm)
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
          
          let selectAlbum = self.takeSelectAlbum(albumUUID: albumUUID, selectRealm: otherRealm)
          
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
