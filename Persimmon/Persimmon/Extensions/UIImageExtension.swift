//
//  UIImageExtension.swift
//  Persimmon
//
//  Created by hyeoktae kwon on 2019/10/18.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import Photos
import AVKit

protocol TempPhoto {}

extension UIImage: TempPhoto {
  func upOrientationImage() -> UIImage? {
    switch imageOrientation {
    case .up:
      return self
    default:
      UIGraphicsBeginImageContextWithOptions(size, false, scale)
      draw(in: CGRect(origin: .zero, size: size))
      let result = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      return result
    }
  }
}

extension PHLivePhoto: TempPhoto {}
extension AVPlayer: TempPhoto {}


