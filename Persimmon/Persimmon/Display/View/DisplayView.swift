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
  
  var isVideo: Bool = false {
    willSet(new) {
      new ? showSlider() : hideSlider()
      layoutIfNeeded()
    }
  }
  
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
  
  let duration: UILabel = {
    let label = UILabel()
    label.backgroundColor = .clear
    label.textAlignment = .center
    label.font = UIFont.boldSystemFont(ofSize: 20)
    label.textColor = .white
    label.isHidden = true
    return label
  }()
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    addSubviews()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    setupSNP()
  }
  
  func showSlider() {
    self.slider.isHidden = false
    self.duration.isHidden = false
  }
  
  func hideSlider() {
    self.slider.isHidden = true
    self.duration.isHidden = true
  }
  
  func showPanel() {
    UIView.transition(with: topView, duration: 0.3, options: .curveEaseInOut, animations: {
      self.topView.alpha = 1
      self.topView.isHidden = false
    }, completion: nil)
    UIView.transition(with: bottomView, duration: 0.3, options: .curveEaseInOut, animations: {
      self.bottomView.alpha = 1
      self.bottomView.isHidden = false
    }, completion: nil)
    UIView.transition(with: slider, duration: 0.3, options: .curveEaseInOut, animations: {
      self.slider.alpha = self.isVideo ? 1 : 0
      self.slider.isHidden = !self.isVideo
    }, completion: nil)
    UIView.transition(with: duration, duration: 0.3, options: .curveEaseInOut, animations: {
      self.duration.alpha = self.isVideo ? 1 : 0
      self.duration.isHidden = !self.isVideo
    }, completion: nil)
  }
  
  func hidePanel() {
    UIView.transition(with: topView, duration: 0.3, options: .curveEaseInOut, animations: {
      self.topView.alpha = 0
      self.topView.isHidden = true
    }, completion: nil)
    UIView.transition(with: bottomView, duration: 0.3, options: .curveEaseInOut, animations: {
      self.bottomView.alpha = 0
      self.bottomView.isHidden = true
    }, completion: nil)
    UIView.transition(with: slider, duration: 0.3, options: .curveEaseInOut, animations: {
      self.slider.alpha = 0
      self.slider.isHidden = true
    }, completion: nil)
    UIView.transition(with: duration, duration: 0.3, options: .curveEaseInOut, animations: {
      self.duration.alpha = 0
      self.duration.isHidden = true
    }, completion: nil)
  }
  
  func hideSNP() {
    topView.snp.remakeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.height.equalToSuperview().multipliedBy(0)
    }
    
    bottomView.snp.remakeConstraints {
      $0.leading.trailing.bottom.equalToSuperview()
      $0.height.equalToSuperview().multipliedBy(0)
    }
    
//    slider.snp.remakeConstraints {
//      $0.leading.trailing.equalToSuperview().inset(20)
//      $0.bottom.equalTo(bottomView.snp.top).offset(-5)
//      $0.height.equalToSuperview().multipliedBy(0)
//    }
  }
  
  func showSNP() {
    topView.snp.remakeConstraints {
      $0.leading.trailing.top.equalToSuperview()
      $0.height.equalToSuperview().multipliedBy(0.1)
    }
    
    bottomView.snp.remakeConstraints {
      $0.leading.trailing.bottom.equalToSuperview()
      $0.height.equalToSuperview().multipliedBy(0.1)
    }
    
//    slider.snp.remakeConstraints {
//      $0.leading.trailing.equalToSuperview()
//      $0.bottom.equalTo(bottomView.snp.top).offset(-5)
//      $0.height.equalToSuperview().multipliedBy(0.05)
//    }
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
    
    duration.snp.makeConstraints {
//          $0.leading.equalTo(slider).offset(20)
          $0.trailing.equalToSuperview().offset(-20)
          $0.height.equalToSuperview().multipliedBy(0.05)
          $0.bottom.equalTo(slider)
    //      $0.width.equalTo(20)
        }
    
    slider.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
      $0.bottom.equalTo(bottomView.snp.top).offset(-5)
      $0.height.equalToSuperview().multipliedBy(0.05)
      $0.trailing.equalTo(duration.snp.leading).offset(-20)
    }
    
  }
  
  func addSubviews() {
    [collection, topView, bottomView, slider, duration].forEach {
      self.addSubview($0)
    }
  }
  
}
