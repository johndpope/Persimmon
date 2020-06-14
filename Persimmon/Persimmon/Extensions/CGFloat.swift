//
//  CGFloat.swift
//  Persimmon
//
//  Created by hyeoktae kwon on 2020/06/14.
//  Copyright © 2020 hyeoktae kwon. All rights reserved.
//

import UIKit


extension CGFloat {
  
  var iOSSize: CGFloat {
    let width = UIScreen.main.bounds.width
    let ratio = self / 375
    return ceil(width * ratio)
  }

}


public extension IntegerLiteralType {
  var i: CGFloat {
    return CGFloat(self).iOSSize
  }
}
