//
//  TopView.swift
//  Persimmon
//
//  Created by hyeoktae kwon on 2019/10/17.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import SnapKit

class TopView: UIView {
  
  // 프로필이미지
  var profileImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.clipsToBounds = true
    imageView.contentMode = .scaleAspectFill
    //    imageView.contentMode = .redraw
    //    imageView.image = UIImage(named: "devy")
    imageView.image = UIImage(named: "tass")
    return imageView
  }()
  
  // 사진 밑에 들어갈 앨범이름
  let albumTitle: UILabel = {
    let label = UILabel()
    label.text = "Tass Devy"
    label.font = UIFont(name: "NanumPen", size: 28)
    label.textColor = .appColor(.appGreenColor)
    return label
  }()
  
  // 사진, 비디오 갯수
  let listNumberLabel: UILabel = {
    let label = UILabel()
    label.text = " 10 Photos, 2 Videos"
    label.font = UIFont(name: "NanumPen", size: 20)
    label.textColor = .appColor(.appGreenColor)
    return label
  }()
  
  var backBtn: UIButton = {
    let button = UIButton(type: .custom)
    button.setTitleColor(.appColor(.appFontColor), for: .normal)
    button.setTitle("⇠", for: .normal)
    button.titleLabel?.font = UIFont(name: "NanumPen", size: 40)
    return button
  }()
  
  let selectBtn: UIButton = {
    let button = UIButton(type: .custom)
    button.setTitleColor(.appColor(.appFontColor), for: .normal)
    button.setTitle("선택", for: .normal)
    button.titleLabel?.font = UIFont(name: "NanumPen", size: 30)
    return button
  }()
  
  // 레이아웃이 시작이 될때마다 불리고
  override func layoutSubviews() {
    super.layoutSubviews()
    profileImageView.layer.cornerRadius = self.frame.height * 0.55 / 2
    self.backgroundColor = UIColor.appColor(.appLayerBorderColor)
    addSubViews()
    setupSNP()
  }
  
  private func addSubViews() {
    [profileImageView, backBtn, albumTitle, listNumberLabel, selectBtn]
      .forEach { self.addSubview($0) }
    //    [label, cameraBtn, cameraLabel, photoLibraryBtn, photoLibraryLabel]
    //      .forEach { containerView.addSubview($0) }
  }
  
  func moveImageView() {
    profileImageView.snp.remakeConstraints {
      $0.top.equalTo(self.snp.topMargin).offset(10)
      $0.width.height.equalTo(self.snp.height).multipliedBy(0.55)
      $0.centerX.equalToSuperview().offset(-50)
    }
  }
  
  func revertImageView() {
    profileImageView.snp.remakeConstraints {
      $0.top.equalTo(self.snp.topMargin).offset(10)
      $0.centerX.equalToSuperview()
      $0.width.height.equalTo(self.snp.height).multipliedBy(0.55)
      
    }
  }
  
  private func setupSNP() {
    backBtn.snp.makeConstraints {
      $0.top.equalTo(self.snp.topMargin).offset(10)
      $0.leading.equalToSuperview().offset(20)
      
    }
    
    selectBtn.snp.makeConstraints {
      $0.top.equalTo(self.snp.topMargin).offset(10)
      $0.trailing.equalToSuperview().offset(-20)
      
    }
    
    profileImageView.snp.makeConstraints {
      $0.top.equalTo(self.snp.topMargin).offset(10)
      $0.centerX.equalToSuperview()
      $0.width.height.equalTo(self.snp.height).multipliedBy(0.55)
      
    }
    
    albumTitle.snp.makeConstraints {
      $0.bottom.equalTo(listNumberLabel.snp.top).offset(-10)
      $0.centerX.equalTo(profileImageView)
      
    }
    
    listNumberLabel.snp.makeConstraints {
      $0.bottom.equalToSuperview().offset(-5)
      $0.centerX.equalTo(profileImageView)
      
    }
  }
  
  deinit {
    print("deinit TopView")
  }
}
