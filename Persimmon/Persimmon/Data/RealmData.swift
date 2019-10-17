//
//  RealmData.swift
//  Persimmon
//
//  Created by hyeoktae kwon on 2019/10/12.
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
  
  func takeSelectAlbum(uuid: String) -> Album? {
    return realm.object(ofType: Album.self, forPrimaryKey: uuid)
  }
  
  // Data -> realm write
  func writeWithLivePhoto(albumUUID: String, asset: TLPHAsset, livePhoto: PHLivePhoto) {
    
    selectAlbum = takeSelectAlbum(uuid: albumUUID)
    let data = asset.fullResolutionImage?.jpegData(compressionQuality: 0.3)
    try! realm.write {
      guard let object = selectAlbum else { return }
      let photo = Photo()
//      photo.livePhoto = livePhoto
//      photo.asset = asset
      photo.photoData = data
      object.photos.append(photo)
      realm.add(object, update: .modified)
    }
  }
  
  // Data -> realm write
    func writeWithPhoto(albumUUID: String, asset: TLPHAsset) {
      
      selectAlbum = takeSelectAlbum(uuid: albumUUID)
      let data = asset.fullResolutionImage?.jpegData(compressionQuality: 0.3)
      try! realm.write {
        guard let object = selectAlbum else { return }
        let photo = Photo()
        photo.photoData = data
        object.photos.append(photo)
        realm.add(object, update: .modified)
      }
    }
  
}



// MARK: - Realm DataModel
// protocol for PrimaryKey
protocol PrimaryKeyAware {
  var uuid: String { get }
  static func primaryKey() -> String?
}

// Album Model
public class Album: Object, PrimaryKeyAware {
  @objc dynamic var title: String = "새 앨범"
  // for Realm Migration test(title2 -> subTitle)
  @objc dynamic var saveDate: Date = Date()
  // UUID for Primary-key and Migarion test
  @objc dynamic var uuid: String = UUID().uuidString
  let photos: List<Photo> = List<Photo>()
  
  override public static func primaryKey() -> String? {
      return "uuid"
  }
}

// Photo Model
public class Photo: Object, PrimaryKeyAware {
  // UUID for Primary-key and Migarion test
  @objc dynamic var uuid: String = UUID().uuidString
  
  @objc dynamic var saveDate: Date = Date()
//  dynamic var asset: TLPHAsset?
//  dynamic var livePhoto: PHLivePhoto?
  @objc dynamic var photoData: Data? = Data()
  
  override public static func primaryKey() -> String? {
      return "uuid"
  }
  
  
  /*
  func test() {
    let options = PHFetchOptions()
    options.sortDescriptors = [
      NSSortDescriptor(key: "creationDate", ascending: false)
    ]
    
    // Get all still images
    let imagesPredicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
    
    // Get all live photos
    let liveImagesPredicate = NSPredicate(format: "(mediaSubtype & %d) != 0", PHAssetMediaSubtype.photoLive.rawValue)
    
    // Combine the two predicates into a statement that checks if the asset
    // complies to one of the predicates.
    options.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [imagesPredicate, liveImagesPredicate])
  }
 */
}




