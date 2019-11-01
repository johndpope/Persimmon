//
//  DisplayView.swift
//  Persimmon
//
//  Created by hyeoktae kwon on 2019/11/02.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import SnapKit

class DisplayView: UIView {
  
  let collection: DisplayCollectionView = {
    let view = DisplayCollectionView()
    return view
  }()
  
  let topView: TopDisplayView = {
    let view = TopDisplayView()
    return view
  }()
  
  let bottomView: BottomDisplayView = {
    let view = BottomDisplayView()
    return view
  }()
  
  let slider: UISlider = {
    let slider = UISlider()
    slider.tintColor = .appColor(.appPersimmonColor)
    slider.thumbTintColor = .appColor(.appFontColor)
    slider.isHidden = true
    return slider
  }()
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    addSubviews()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    setupSNP()
  }
  
  func setupSNP() {
    collection.snp.makeConstraints {
      $0.leading.trailing.top.bottom.equalToSuperview()
    }
    
    topView.snp.makeConstraints {
      $0.leading.trailing.top.equalToSuperview()
      $0.height.equalToSuperview().multipliedBy(0.1)
    }
    
    bottomView.snp.makeConstraints {
      $0.leading.trailing.bottom.equalToSuperview()
      $0.height.equalToSuperview().multipliedBy(0.1)
    }
    
    slider.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalTo(bottomView.snp.top).offset(-5)
      $0.height.equalToSuperview().multipliedBy(0.05)
    }
  }
  
  func addSubviews() {
    [collection, topView, bottomView, slider].forEach {
      self.addSubview($0)
    }
  }
  
}
