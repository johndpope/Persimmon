//
//  PhotoListView.swift
//  Persimmon
//
//  Created by Jeon-heaji on 2019/10/14.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import SnapKit

class PhotoListView: UIView {
  
  lazy var backBtn: UIButton = {
    let button = UIButton(type: .custom)
    button.setTitleColor(.appColor(.appFontColor), for: .normal)
    button.setTitle("⟨", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 40, weight: .semibold)
    return button
  }()

  
  // 프로필이미지
  lazy var profileImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.layer.cornerRadius = 75
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
    label.font = UIFont(name: "Palatino", size: 20)
    label.textColor = .appColor(.appGreenColor)
    return label
  }()
  
  // 사진, 비디오 갯수
  let listNumberLabel: UILabel = {
    let label = UILabel()
    label.text = " 10 Photos, 2 Videos"
    label.font = UIFont(name: "Palatino", size: 14)
    label.textColor = .appColor(.appGreenColor)
    return label
  }()
  
  // 더하기 버튼
  let addBtn: UIButton = {
    let button = UIButton(type: .custom)
    button.setImage(UIImage(named: "addButton"), for: .normal)
    button.tintColor = UIColor.appColor(.appFontColor)
    return button
  }()
  
  // alert만들기위한 뷰
  let containerView: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    view.alpha = 0.8
    view.layer.borderWidth = 0.3
    view.layer.borderColor = UIColor.appColor(.appFontColor).cgColor
    return view
  }()
  
  let getLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont(name: "Didot", size: 20)
    label.text = "가져오기"
    label.textColor = .appColor(.appGreenColor)
    return label
  }()
  
  let cameraLabel: UILabel = {
    let label = UILabel()
    label.text = "카메라"
    label.textColor = .appColor(.appGreenColor)
    label.font = UIFont.systemFont(ofSize: 15, weight: .light)
    
    return label
  }()
  
  let photoLibraryLabel: UILabel = {
    let label = UILabel()
    label.text = "앨범"
    label.textColor = .appColor(.appGreenColor)
    label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
    return label
  }()
  
  let cameraBtn: UIButton = {
    let button = UIButton(type: .custom)
    button.setImage(UIImage(named: "photoCamera"), for: .normal)
    button.tintColor = UIColor.appColor(.appGreenColor)
    return button
  }()
  
  let photoLibraryBtn: UIButton = {
    let button = UIButton(type: .custom)
    button.setImage(UIImage(named: "photoAttach"), for: .normal)
    button.tintColor = UIColor.appColor(.appGreenColor)
    return button
  }()
  
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    addSubViews()
    setupSNP()
    
//    image(with: profileImageView.image!, scaledTo: CGSize(width: 150, height: 150))
//    resizeImage(image: profileImageView.image!, targetSize: CGSize(width: 150, height: 150))
  }
  

  func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
    let size = image.size
    
    let widthRatio  = targetSize.width  / size.width
    let heightRatio = targetSize.height / size.height
    
    // newSize - 사각형만들기
    var newSize: CGSize
    if(widthRatio > heightRatio) {
      newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
    } else {
      newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
    }
    
    // 계산한 사각형, 아래에서 사용 될 사이즈
    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
    
    // ImageContext를 사용하여 rect에 크기 조정하기

    UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
    image.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    profileImageView.image = newImage
    
    return newImage ?? UIImage()
  }
  

  private func addSubViews() {
    [profileImageView, backBtn, albumTitle, listNumberLabel, addBtn]
      .forEach { self.addSubview($0) }
//    [label, cameraBtn, cameraLabel, photoLibraryBtn, photoLibraryLabel]
//      .forEach { containerView.addSubview($0) }
  }
  
  func createAlert() {
    
    [containerView]
         .forEach { self.addSubview($0) }
    
    [getLabel, cameraBtn, cameraLabel, photoLibraryBtn, photoLibraryLabel]
      .forEach { containerView.addSubview($0) }
    
    containerView.snp.makeConstraints {
      $0.bottom.equalToSuperview()
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(UIScreen.main.bounds.height / 3)
    }
    
    getLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(10)
      $0.centerX.equalToSuperview()
    }
    
    photoLibraryBtn.snp.makeConstraints {
      $0.top.equalTo(getLabel.snp.bottom).offset(70)
      $0.centerX.equalToSuperview().multipliedBy(0.5)
      $0.width.height.equalTo(50)
    }
    
    photoLibraryLabel.snp.makeConstraints {
      $0.top.equalTo(photoLibraryBtn.snp.bottom).offset(15)
      $0.centerX.equalTo(photoLibraryBtn)
    }
    
    cameraBtn.snp.makeConstraints {
      $0.top.equalTo(getLabel.snp.bottom).offset(67)
      $0.centerX.equalToSuperview().multipliedBy(1.4)
      $0.width.height.equalTo(60)
    }
    cameraLabel.snp.makeConstraints {
      $0.top.equalTo(cameraBtn.snp.bottom).offset(15)
      $0.centerX.equalTo(cameraBtn)
    }
    
  }

  
  private func setupSNP() {
    
    backBtn.snp.makeConstraints { 
      $0.top.equalToSuperview().offset(UIScreen.main.bounds.height * 0.07)
      $0.leading.equalToSuperview().inset(30)
    }
    
    profileImageView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(UIScreen.main.bounds.height * 0.10)
      $0.centerX.equalToSuperview()
      $0.width.height.equalTo(150)
    }
    
    albumTitle.snp.makeConstraints {
      $0.top.equalTo(profileImageView.snp.bottom).offset(20)
      $0.centerX.equalToSuperview()
    }
     
     
    
    listNumberLabel.snp.makeConstraints {
      $0.top.equalTo(albumTitle.snp.bottom).offset(20)
      $0.centerX.equalToSuperview()
    }
    
    addBtn.snp.makeConstraints {
      $0.bottom.equalTo(-UIScreen.main.bounds.height / 6)
      $0.trailing.equalToSuperview().offset(-30)
      $0.width.height.equalTo(50)
    }
    
    
    
    
    
  }
  

  
  
}


