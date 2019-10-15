//
//  BundleExtention.swift
//  Persimmon
//
//  Created by hyeoktae kwon on 2019/10/15.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import Foundation
import TLPhotoPicker

extension Bundle {
  func bundle() -> Bundle {
    let podBundle = Bundle(for: TLBundle.self)
    if let url = podBundle.url(forResource: "TLPhotoPicker", withExtension: "bundle") {
      let bundle = Bundle(url: url)
      return bundle ?? podBundle
    }
    return podBundle
  }
}
