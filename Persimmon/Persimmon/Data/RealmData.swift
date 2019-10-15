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
  
  private init() {
    // realm configuration
        let configBlock: MigrationBlock = { (migration, oldVersion) in
          print("start Migration")
    //      if oldVersion < 2 {
    //        migration.enumerateObjects(ofType: Album.className()) { (old, new) in
    //          // need to migration
    ////          new?["uuid"] = UUID().uuidString
    ////          new?["title"] = "test"
    //        }
    //      }
          print("Migration complete.")
        }
        
        Realm.Configuration.defaultConfiguration = Realm.Configuration(schemaVersion: 1, migrationBlock: configBlock)
//    print("here URL:  ", Realm.Configuration.defaultConfiguration.fileURL)
  }
  
  // realm init
  let realm = try! Realm()
  
  // realm object, rx기반이라 반응형, 쓰기 및 삭제 하면 바로 적용
  lazy var albums = realm.objects(Album.self)
  
  var selectAlbum: Album?
  
  // 이미지 익스포트를 위함
  lazy var imageManager: PHCachingImageManager = {
      return PHCachingImageManager()
  }()
  
//  lazy var token = albums.observe { (album) in
//    switch album {
//    case .update(_, deletions: _, insertions: _, modifications: _):
//      print("update NewAlbum")
//    case .initial(let new):
//      print("initial NewAlbum")
//    case .error(let err):
//      dump(err)
//    }
//    print("finish write")
//  }
//
//  lazy var selectToken = selectAlbum?.observe { (change) in
//    switch change {
//    case .change(_):
//      print("seve success")
//    case .deleted:
//      print("deleted")
//    case .error(let err):
//      print("err: ", err)
//    }
//  }
  
  // add new album
  func addAlbum(title: String?) {
    try! realm.write {
      let newAlbum = Album()
      newAlbum.title = title ?? "새 앨범"
      realm.add(newAlbum, update: .modified)
    }
  }
  
//  deinit {
//    token.invalidate()
//    selectToken?.invalidate()
//  }
  
  // Data -> realm write
  func writeWithLivePhoto(albumUUID: String, asset: TLPHAsset, livePhoto: PHLivePhoto) {
    
    selectAlbum = realm.object(ofType: Album.self, forPrimaryKey: albumUUID)
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
  
//  @discardableResult
//  func getDataWithAsset(asset: TLPHAsset, size: CGSize = CGSize(width: 160, height: 160), progressBlock: Photos.PHAssetImageProgressHandler? = nil, completionBlock:@escaping (PHLivePhoto,Bool)-> Void ) -> PHImageRequestID {
//
//    let type = asset.type
//
//    switch type {
//    case .livePhoto:
//      let options = PHLivePhotoRequestOptions()
//      options.deliveryMode = .highQualityFormat
//      options.isNetworkAccessAllowed = true
//      options.progressHandler = progressBlock
//    case .photo:
//      ()
//    case .video:
//      ()
//    }
//
//
//
//    return 2
//  }
  
}



// MARK: - Realm DataModel
// Album Model
public class Album: Object {
  @objc dynamic var title: String = "새 앨범"
  // for Realm Migration test(title2 -> subTitle)
  @objc dynamic var saveDate: Date = Date()
  // UUID for Primary-key and Migarion test
  @objc dynamic var uuid: String = UUID().uuidString
  let photos: List<Photo> = List<Photo>()
  
  //     set primary-key
//  override public class func primaryKey() -> String? {
//          return "uuid"
//      }
  
  override public static func primaryKey() -> String? {
      return "uuid"
  }
}

// Photo Model
public class Photo: Object {
  @objc dynamic var saveDate: Date = Date()
//  dynamic var asset: TLPHAsset?
//  dynamic var livePhoto: PHLivePhoto?
  @objc dynamic var photoData: Data? = Data()
  
  
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




