//
//  Isaac.swift
//  Persimmon
//
//  Created by hyeoktae kwon on 2020/06/14.
//  Copyright © 2020 hyeoktae kwon. All rights reserved.
//

import Foundation
import Toast_Swift

final class Isaac { // 여기서 토스트 작업 하면 됨
  static let shared = Isaac()
  
//  enum ToastType: String {
//    case checkPW = "비번 확인요망!"
//  }
  
  private init() {
    ToastManager.shared.position = .bottom
    
    
  }
  
//  static let windows = UIApplication.topViewController()?.view
  static var windows: UIView? {
    UIApplication.shared.windows.last
  }
  
  class func toast(_ text: String, view: UIView? = nil) {
    DispatchQueue.main.async {
      guard let view = windows else { return }
      view.makeToast(" " + text + " ")
    }
//    if let view = view {
//
//      view.makeToast(" " + text + " ")
////      view.makeToastActivity(.top)
//    } else {
//      guard let view = windows else { return }
//
//      view.makeToast(" " + text + " ")
//    }
    
  }
  
//  class func toast(_ text: ToastType) {
//    guard let view = windows else { return }
//    view.makeToast("    " + text.rawValue + "    ")
//  }
}
