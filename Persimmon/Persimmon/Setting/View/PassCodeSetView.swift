//
//  PassCodeSettingView.swift
//  Persimmon
//
//  Created by Jeon-heaji on 2019/10/16.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import SnapKit

class PassCodeSetView: UIView {
  
  lazy var backBtn: UIButton = {
    let button = UIButton(type: .custom)
    button.setTitleColor(.appColor(.appFontColor), for: .normal)
    button.setTitle("⇠", for: .normal)
    button.titleLabel?.font = UIFont(name: "NanumPen", size: 40)
    return button
  }()
  
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    self.backgroundColor = .white
    addSubViews()
    setupSNP()
    
  }
  
  
  private func addSubViews() {
    []
      .forEach { self.addSubview($0) }

  }
  
  private func setupSNP() {
    
  }
  

}
