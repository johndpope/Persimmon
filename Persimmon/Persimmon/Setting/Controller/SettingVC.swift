//
//  SettingVC.swift
//  Persimmon
//
//  Created by Jeon-heaji on 2019/10/14.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit

class SettingVC: UIViewController {
  
  let settingView = SettingView()
  
  override func loadView() {
    self.view = settingView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    settingView.delegate = self
    settingView.scaleBtn.addTarget(self, action: #selector(didTapScaleBtn(_:)), for: .touchUpInside)
    
  }
  
  @objc func didTapScaleBtn(_ sender: UIButton) {
    sender.isSelected.toggle()
    UserDefaults.standard.set(sender.isSelected, forKey: "scale")
    print(UserDefaults.standard.bool(forKey: "scale"))
  }
  
}

extension SettingVC: SettingViewDelegate {
  func tableCellDidTap(indexPath: IndexPath) {
    switch indexPath {
    case IndexPath(row: 0, section: 0):
      print("계정")
    case IndexPath(row: 0, section: 1):
      let passCodeSetVC = ChangePassCodeVC()
      navigationController?.pushViewController(passCodeSetVC, animated: true)
    case IndexPath(row: 0, section: 2):
      print("기부하기")
    default:
      break
    }
  }
  
  
}
