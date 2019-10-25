//
//  CountView.swift
//  Persimmon
//
//  Created by hyeoktae kwon on 2019/10/23.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import SnapKit

class CountView: UIView {
  // 사진, 비디오 갯수
  let listNumberLabel: UILabel = {
    let label = UILabel()
    label.text = " 10 Photos, 2 Videos"
    label.font = UIFont(name: "NanumPen", size: 25)
    label.textColor = .appColor(.appGreenColor)
    return label
  }()
  
  let deleteBtn: UIButton = {
    let button = UIButton(type: .custom)
    button.setTitleColor(.appColor(.appFontColor), for: .normal)
    button.setTitle("선택", for: .normal)
    button.setTitle("삭제", for: .selected)
    button.titleLabel?.font = UIFont(name: "NanumPen", size: 25)
    return button
  }()
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.backgroundColor = UIColor.appColor(.appLayerBorderColor)
    addSubViews()
    setupSNP()
  }
  
  private func addSubViews() {
    [listNumberLabel, deleteBtn]
      .forEach { self.addSubview($0) }
  }
  
  private func setupSNP() {
    listNumberLabel.snp.makeConstraints {
      $0.centerX.centerY.equalTo(self)
      
    }
    
    deleteBtn.snp.makeConstraints {
      $0.trailing.equalTo(self).offset(-10)
      $0.height.equalTo(listNumberLabel)
      $0.centerY.equalTo(self)
      
    }
    
  }
  
  deinit {
    print("deinit CountView")
  }
  
  
}