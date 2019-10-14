//
//  SelectAlbumView.swift
//  Persimmon
//
//  Created by Jeon-heaji on 2019/10/14.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit

class SelectAlbumView: UIView {
  lazy var backBtn: UIButton = {
    let button = UIButton(type: .custom)
    button.setTitleColor(.appColor(.appFontColor), for: .normal)
    button.setTitle("⟨", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 40, weight: .semibold)
    return button
  }()
  

  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    self.backgroundColor = .white
    addSubViews()
    setupSNP()
  }
  
  private func addSubViews() {
    [backBtn]
      .forEach { self.addSubview($0) }
  
  }
  private func setupSNP() {
    
    backBtn.snp.makeConstraints {
      $0.top.equalToSuperview().offset(UIScreen.main.bounds.height * 0.07)
      $0.leading.equalToSuperview().inset(30)
    }
  }
}
