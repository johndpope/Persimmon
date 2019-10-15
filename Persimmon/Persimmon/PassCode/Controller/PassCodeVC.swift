//
//  PassCodeVC.swift
//  Persimmon
//
//  Created by hyeoktae kwon on 2019/10/12.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit


class PassCodeVC: UIViewController {
  
  var isFirst: Bool = false
  let launchPassCodeView = LaunchPassCodeView()
  
  let attributes = [NSAttributedString.Key.font : UIFont(name: "NanumPen", size: 20)!, NSAttributedString.Key.foregroundColor : UIColor.appColor(.appFontColor)]
  
  override func loadView() {
    self.view = launchPassCodeView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    launchPassCodeView.passCodeView.delegate = self
  }
  
}

extension PassCodeVC: PassCodeViewDelegate {
  func didTapButton(sender: UIButton) {
    let vc = MainTabBarController()
    let navi = UINavigationController(rootViewController: vc)

    
    navi.modalPresentationStyle = .fullScreen
    navi.modalTransitionStyle = .crossDissolve
    navi.navigationBar.isHidden = true
    self.present(navi, animated: true)
  
  }
  
}
