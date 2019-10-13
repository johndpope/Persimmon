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
  
  let attributes = [NSAttributedString.Key.font : UIFont(name: "Palatino", size: 20)!, NSAttributedString.Key.foregroundColor : UIColor.appColor(.appFontColor)]
  
  
  let code = "1234"
  
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
    let vc = AlbumListVC()
    let navi = UINavigationController(rootViewController: vc)
    
//    let attirbute = [NSAttributedString.Key.foregroundColor: UIColor.appColor(.appFontColor),
//    NSAttributedString.Key.font: UIFont(name: "Palatino", size: 21)!]
//
//    let textAttributes:[NSAttributedString.Key: Any] = [NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue):UIColor.blue, NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue):UIFont(name:"Palatino", size: 17)!]
//       navigationController?.navigationBar.titleTextAttributes = textAttributes

    
    navi.modalPresentationStyle = .fullScreen
    navi.modalTransitionStyle = .crossDissolve
    
    navi.navigationBar.prefersLargeTitles = true
//    navi.navigationBar.titleTextAttributes = attirbute
    vc.title = "사진첩"
    self.present(navi, animated: true)
  
    
  }
  
}
