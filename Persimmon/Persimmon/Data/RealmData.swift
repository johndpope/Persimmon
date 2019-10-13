//
//  RealmData.swift
//  Persimmon
//
//  Created by hyeoktae kwon on 2019/10/12.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import Foundation
import RealmSwift
import TLPhotoPicker


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
}




