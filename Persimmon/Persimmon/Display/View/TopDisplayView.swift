//
//  TopDisplayView.swift
//  Persimmon
//
//  Created by hyeoktae kwon on 2019/11/02.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import SnapKit

class TopDisplayView: UIView {
  
  var backBtn: UIButton = {
    let button = UIButton(type: .custom)
    button.setTitleColor(.appColor(.appFontColor), for: .normal)
    button.setTitle("⇠", for: .normal)
    button.titleLabel?.font = UIFont(name: "NanumPen", size: 40)
    return button
  }()
  
  var countLabel: UILabel = {
    let label = UILabel()
    label.text = ""
    label.textAlignment = .center
    label.font = UIFont(name: "NanumPen", size: 40)
    return label
  }()
  
  var sharedBtn: UIButton = {
    let button = UIButton(type: .custom)
    button.setTitleColor(.appColor(.appFontColor), for: .normal)
    button.setTitle("앨범으로", for: .normal)
    button.titleLabel?.font = UIFont(name: "NanumPen", size: 40)
    return button
  }()
  
  lazy var stackView: UIStackView = {
    let view = UIStackView(arrangedSubviews: [backBtn, countLabel, sharedBtn])
    view.distribution = .fillEqually
    view.alignment = .firstBaseline
    view.axis = .horizontal
    return view
  }()
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    self.backgroundColor = .appColor(.appLayerBorderColor)
    self.addSubview(stackView)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    stackView.snp.makeConstraints {
      $0.leading.trailing.top.bottom.equalTo(self)
    }
  }
  
}
