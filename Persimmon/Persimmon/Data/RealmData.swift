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
  
  private init() {}
  
  // realm init
  let realm = try! Realm()
  
  // realm object, rx기반이라 반응형, 쓰기 및 삭제 하면 바로 적용
  lazy var albums = realm.objects(Album.self)
  
  // 이미지 익스포트를 위함
  lazy var imageManager: PHCachingImageManager = {
      return PHCachingImageManager()
  }()
  
  // Data -> realm write
  private func realmWrite(albumUUID: String, photo: TLPHAsset) {
    
  }
  
  @discardableResult
  func getDataWithAsset(asset: TLPHAsset, size: CGSize = CGSize(width: 160, height: 160), progressBlock: Photos.PHAssetImageProgressHandler? = nil, completionBlock:@escaping (PHLivePhoto,Bool)-> Void ) -> PHImageRequestID {
    
    let type = asset.type
    
    switch type {
    case .livePhoto:
      let options = PHLivePhotoRequestOptions()
      options.deliveryMode = .highQualityFormat
      options.isNetworkAccessAllowed = true
      options.progressHandler = progressBlock
    case .photo:
      ()
    case .video:
      ()
    }
    
    
    
    return 2
  }
  
}



// MARK: - Realm DataModel
// Album Model
public class Album: Object {
  dynamic var title: String = ""
  // for Realm Migration test(title2 -> subTitle)
  dynamic var subTitle: String = ""
  dynamic var saveDate: Date = Date()
  // UUID for Primary-key and Migarion test
  dynamic var uuid: String = UUID().uuidString
  let photos: List<Photo> = List<Photo>()
  
  //     set primary-key
//  override public class func primaryKey() -> String? {
//          return "uuid"
//      }
}

// Photo Model
public class Photo: Object {
  //  dynamic var saveDate: Date = Date()
  dynamic var imageData: TLPHAsset = TLPHAsset(asset: nil)
  dynamic var data: PHLivePhoto?
  
  lazy var ee = data._rlmInferWrappedType()
  
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
}




