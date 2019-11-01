//
//  DisplayCollectionCell.swift
//  Persimmon
//
//  Created by Jeon-heaji on 2019/10/31.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import AVKit
import PhotosUI

class DisplayCollectionCell: UICollectionViewCell {
  static let identifier = "DisplayCollectionCell"
  
  var cellType: String?
  var imageName: String?
  var videoName: String?
  
  let imageView: UIImageView = {
    let view = UIImageView()
    view.contentMode = .scaleAspectFit
    return view
  }()
  
  let livePhotoView: PHLivePhotoView = {
    let view = PHLivePhotoView()
    view.contentMode = .scaleAspectFit
    return view
  }()
}
