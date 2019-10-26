//
//  PopUpView.swift
//  Persimmon
//
//  Created by hyeoktae kwon on 2019/10/26.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import SnapKit

class PopUpView: UIView {
  
  let cancelBtn: UIButton = {
    let button = UIButton(type: .custom)
    button.setTitleColor(.appColor(.appFontColor), for: .normal)
    button.setTitle("취소", for: .normal)
    button.titleLabel?.font = UIFont(name: "NanumPen", size: 20)
    return button
  }()
  
  let modifyBtn: UIButton = {
    let button = UIButton(type: .custom)
    button.setTitleColor(.appColor(.appFontColor), for: .normal)
    button.setTitle("이동", for: .normal)
    button.titleLabel?.font = UIFont(name: "NanumPen", size: 20)
    return button
  }()
  
  let deleteBtn: UIButton = {
    let button = UIButton(type: .custom)
    button.setTitleColor(.red, for: .normal)
    button.setTitle("삭제", for: .normal)
    button.titleLabel?.font = UIFont(name: "NanumPen", size: 20)
    return button
  }()
  
  lazy var stackView: UIStackView = {
    let sview = UIStackView(arrangedSubviews: [deleteBtn, modifyBtn, cancelBtn])
    sview.spacing = 10
    sview.axis = .horizontal
    sview.distribution = .equalSpacing
    return sview
  }()
  
  init(frame: CGRect, modify: String) {
    super.init(frame: frame)
    self.backgroundColor = .appColor(.appLayerBorderColor)
    modifyBtn.setTitle(modify, for: .normal)
    self.addSubview(stackView)
    setupSNP()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupSNP() {
    stackView.snp.makeConstraints {
      $0.leading.trailing.top.bottom.equalTo(self)
    }
  }
  

}
