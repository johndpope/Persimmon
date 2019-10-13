//
//  PhotoListViewEmpty.swift
//  Persimmon
//
//  Created by Jeon-heaji on 2019/10/14.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import SnapKit

class PhotoListViewEmpty: UIView {
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "타이틀"
    return label
  }()
  
  let view: UIView = {
    let view = UIView()
    view.layer.borderWidth = 0.3
    return view
  }()
  
  let imageLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.text = " 이미지 없음\n Tap the + button to add photos. "
    return label
  }()
  
  
  
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    addSubViews()
    setupSNP()
  }
  
  
  private func addSubViews() {
     [titleLabel, view, imageLabel]
       .forEach { self.addSubview($0) }
   }
   
  private func setupSNP() {
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(UIScreen.main.bounds.height * 0.07)
      $0.centerX.equalToSuperview()
    }
    
    view.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(150)
      $0.leading.trailing.equalToSuperview().inset(30)
    }
    
    imageLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.centerY.equalToSuperview()
    }
  }


}
