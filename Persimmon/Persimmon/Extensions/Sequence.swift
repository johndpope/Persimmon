//
//  Sequence.swift
//  Persimmon
//
//  Created by hyeoktae kwon on 2020/06/14.
//  Copyright © 2020 hyeoktae kwon. All rights reserved.
//

import Foundation

extension Array {
  subscript (safe index: Int) -> Element? {
    return indices ~= index ? self[index] : nil
  }
}
