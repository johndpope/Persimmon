//
//  AlbumListTableCell.swift
//  Persimmon
//
//  Created by Jeon-heaji on 2019/10/17.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import SnapKit

class AlbumListTableCell: UITableViewCell {
  
  static let identifier = "AlbumListTableCell"
  var albumUUID: String = ""
  
  lazy var albumImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.clipsToBounds = true
    return imageView
  }()
  
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.text = "Tass Devy"
    label.font = UIFont(name: "NanumPen", size: 28)
    label.textColor = .appColor(.appGreenColor)
    return label
  }()
  
  lazy var subTitleLabel: UILabel = {
    let label = UILabel()
    label.text = "Tass Devy"
    label.font = UIFont(name: "NanumPen", size: 20)
    label.textColor = .appColor(.appGreenColor)
    return label
  }()
  
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    
    addSubViews()
    setupSNP()
  }
  
  private func addSubViews() {
    [albumImageView, titleLabel, subTitleLabel]
      .forEach { self.addSubview($0) }
  }
  
  private func setupSNP() {
    albumImageView.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().offset(10)
      $0.width.height.equalTo(UIScreen.main.bounds.width / 4.5)
    }
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(20)
      $0.centerX.equalToSuperview().offset(40)
    }
    subTitleLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview().offset(40)
      $0.top.equalTo(titleLabel.snp.bottom).offset(10)
    }
  }
  
  
}
