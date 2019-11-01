//
//  BottomDisplayView.swift
//  Persimmon
//
//  Created by hyeoktae kwon on 2019/11/02.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit

class BottomDisplayView: UIView {
  
  var graveBtn: UIButton = {
    let button = UIButton(type: .custom)
    button.setTitleColor(.appColor(.appFontColor), for: .normal)
    button.setTitle("버리기", for: .normal)
    button.titleLabel?.font = UIFont(name: "NanumPen", size: 40)
    return button
  }()
  
  var muteBtn: UIButton = {
    let button = UIButton(type: .system)
    button.setTitleColor(.appColor(.appFontColor), for: .normal)
    button.setTitle("소리끔", for: .normal)
    button.setTitle("소리킴", for: .selected)
    button.titleLabel?.font = UIFont(name: "NanumPen", size: 40)
    return button
  }()
  
  var playBtn: UIButton = {
    let button = UIButton(type: .system)
    button.setTitleColor(.appColor(.appFontColor), for: .normal)
    button.setTitle("재생", for: .normal)
    button.setTitle("정지", for: .selected)
    button.titleLabel?.font = UIFont(name: "NanumPen", size: 40)
    return button
  }()
  
  lazy var stackView: UIStackView = {
    let view = UIStackView(arrangedSubviews: [graveBtn, playBtn, muteBtn])
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
