//
//  RealmData.swift
//  Persimmon
//
//  Created by hyeoktae kwon on 2019/10/12.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import Foundation
import RealmSwift


// MARK: - Realm DataModel
// protocol for PrimaryKey
protocol PrimaryKeyAware {
  var photoUUID: String { get }
  static func primaryKey() -> String?
}

// Album Model
public class Album: Object {
  @objc dynamic var title: String = "새 앨범"
  // for Realm Migration test(title2 -> subTitle)
  @objc dynamic var saveDate: Date = Date()
  // UUID for Primary-key and Migarion test
  @objc dynamic var albumUUID: String = UUID().uuidString
  let photos: List<Photo> = List<Photo>()
  
  override public static func primaryKey() -> String? {
      return "albumUUID"
  }
}

// Photo Model
public class Photo: Object, PrimaryKeyAware {
  // UUID for Primary-key
  @objc dynamic var photoUUID: String = ""
  @objc dynamic var albumUUID: String = ""
  @objc dynamic var saveDate: Date = Date()
//  dynamic var asset: TLPHAsset?
//  dynamic var livePhoto: PHLivePhoto?
  @objc dynamic var type: String = ""
  @objc dynamic var imageName: String = ""
  @objc dynamic var videoName: String = ""
  @objc dynamic var thumbnail: String = "thumbnail.png"
  
  override public static func primaryKey() -> String? {
      return "photoUUID"
  }
  
  
}

// Grave Model
public class Grave: Object {
  @objc dynamic var title: String = "Grave"
  let photos: List<Photo> = List<Photo>()
  
  override public static func primaryKey() -> String? {
      return "title"
  }
  
  
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
