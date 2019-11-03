//
//  DisplayModel.swift
//  Persimmon
//
//  Created by hyeoktae kwon on 2019/11/02.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import Foundation

struct DisplayModel {
  var object: Album?
  var selectedCell: IndexPath?
  var albumUUID: String?
  
  init(uuid: String, indexPath: IndexPath) {
    self.albumUUID = uuid
    self.selectedCell = indexPath
    self.object = RealmSingleton.shared.takeSelectAlbum(albumUUID: uuid)
  }
  
}
