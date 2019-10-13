//
//  PhotoListView.swift
//  Persimmon
//
//  Created by Jeon-heaji on 2019/10/14.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit

class PhotoListView: UIView {
  
  let backBtn: UIButton = {
    let button = UIButton()
    return button
  }()
  
  let profileImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.layer.cornerRadius = 55
    imageView.clipsToBounds = true
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  let listNumberLabel: UILabel = {
    let label = UILabel()
    return label
  }()
  
  let addBtn: UIButton = {
    let button = UIButton()
    button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
    return button
  }()
  
  let containerView: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    view.alpha = 0.6
    return view
  }()
  
  let label: UILabel = {
    let label = UILabel()
    label.text = "가져오기"
    label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
    return label
  }()
  let cameraLabel: UILabel = {
    let label = UILabel()
    label.text = "카메라"
    label.textColor = .appColor(.appGreenColor)
    label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    return label
  }()
  
  let photoLibraryLabel: UILabel = {
    let label = UILabel()
    label.text = "앨범"
    label.textColor = .appColor(.appGreenColor)
    label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    return label
  }()
  
  let cameraBtn: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "persimmonicon1"), for: .normal)
    return button
  }()
  
  let photoLibraryBtn: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "persimmonicon1"), for: .normal)
    return button
  }()
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    addSubViews()
    setupSNP()
  }
  
  @objc func didTapButton(_ sender: UIButton) {
    
    creatAlert()
    
  }
  
  
  private func addSubViews() {
    [backBtn, profileImageView, listNumberLabel, addBtn]
      .forEach { self.addSubview($0) }
//    [label, cameraBtn, cameraLabel, photoLibraryBtn, photoLibraryLabel]
//      .forEach { containerView.addSubview($0) }
  }
  
  private func creatAlert() {
    
    [containerView]
         .forEach { self.addSubview($0) }
    
    [label, cameraBtn, cameraLabel, photoLibraryBtn, photoLibraryLabel]
      .forEach { containerView.addSubview($0) }
    
    containerView.snp.makeConstraints {
      $0.bottom.equalToSuperview().offset(-100)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(UIScreen.main.bounds.height / 6)
    }
    
  }
  
  private func setupSNP() {
    
  }
  
}
