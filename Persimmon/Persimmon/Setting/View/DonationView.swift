//
//  DonationView.swift
//  Persimmon
//
//  Created by Jeon-heaji on 2019/10/20.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import SnapKit


class DonationView: UIView {
  
  let topView: UIView = {
    let topView = UIView()
    topView.backgroundColor = UIColor.appColor(.appFontColor)
    return topView
  }()
  
  lazy var settingLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont(name: "NanumPen", size: 21)
//    label.textColor = .appColor(.appFontColor)
    label.textColor = .white
    label.textAlignment = .center
    label.numberOfLines = 0
    label.text = " 단감은 여러분들의 후원을 통해 유지됩니다.\n 작은 후원과 기부가 모여 개발자에게 큰 동기부여가 되고 있습니다. \n 고맙습니다. :) \n \n tass & devy \n \n"
    return label
  }()
  
  lazy var persimmonImg: UIImageView = {
    let imageView = UIImageView()
    imageView.clipsToBounds = true
    imageView.contentMode = .scaleAspectFit
    imageView.image = UIImage(named: "icon")
    return imageView
  }()
  
  lazy var backBtn: UIButton = {
    let button = UIButton(type: .custom)
    button.setTitleColor(UIColor.white, for: .normal)
    button.setTitle("⇠", for: .normal)
    button.titleLabel?.font = UIFont(name: "NanumPen", size: 30)
    return button
  }()
  
  
  lazy var githubBtn: UIButton = {
    let button = UIButton(type: .custom)
    button.setTitleColor(.appColor(.appFontColor), for: .normal)
    button.setImage(UIImage(named: "github"), for: .normal)
    button.tintColor = .white
    return button
  }()
  
  lazy var facebookBtn: UIButton = {
    let button = UIButton(type: .custom)
    button.setTitleColor(.appColor(.appFontColor), for: .normal)
    button.setImage(UIImage(named: "facebook"), for: .normal)
    button.tintColor = .white
    return button
  }()
  
  let bottomView: UIView = {
    let bottomView = UIView()
    return bottomView
  }()
  
  let selectLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont(name: "NanumPen", size: 21)
    label.numberOfLines = 0
    label.textColor = .lightGray
    label.text = "기부 프로그램 선택\n 단감의 모든 서비스는 무료입니다.\n 기부하지 않으셔도 좋아요 :)"
//    label.textColor = .appColor(.appFontColor)
    return label
  }()
  
  lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.dataSource = self
    tableView.delegate = self
    return tableView
  }()
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    
    self.backgroundColor = .white
    addSubViews()
    setupSNP()
    setupTableView()
    
  }
  

  
  private func setupTableView() {
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
  }
  
  
  private func addSubViews() {
    [topView, bottomView, tableView]
      .forEach { self.addSubview($0) }
    [persimmonImg, backBtn, settingLabel, githubBtn, facebookBtn]
      .forEach { topView.addSubview($0) }
    [selectLabel]
      .forEach { bottomView.addSubview($0) }
    
  }
  
  private func setupSNP() {
    
    topView.snp.makeConstraints {
        $0.top.leading.trailing.equalToSuperview()
        $0.height.equalToSuperview().multipliedBy(0.38)
      }
    persimmonImg.snp.makeConstraints {
         $0.top.equalTo(self.snp.topMargin).offset(20)
         $0.centerX.equalToSuperview()
         $0.width.height.equalTo(topView.snp.height).multipliedBy(0.15)
       }
    
    backBtn.snp.makeConstraints {
      $0.top.equalTo(self.snp.topMargin).offset(10)
      $0.leading.equalToSuperview().offset(20)
      $0.width.height.equalTo(23)
    }
    
    settingLabel.snp.makeConstraints {
      $0.top.equalTo(persimmonImg.snp.bottom).offset(10)
      $0.centerX.equalToSuperview()
    }
    
    githubBtn.snp.makeConstraints {
      $0.bottom.equalTo(topView.snp.bottom).offset(-10)
      $0.centerX.equalToSuperview().offset(-20)
      
    }
    facebookBtn.snp.makeConstraints {
      $0.bottom.equalTo(githubBtn.snp.bottom)
      $0.leading.equalTo(githubBtn.snp.trailing).offset(10)
    }
    
    
    bottomView.snp.makeConstraints {
       $0.top.equalTo(topView.snp.bottom)
       $0.leading.trailing.equalToSuperview()
       $0.height.equalToSuperview().multipliedBy(0.11)
     }
    selectLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(10)
      $0.leading.equalToSuperview().offset(20)
    }
    
    
    tableView.snp.makeConstraints {
      $0.top.equalTo(bottomView.snp.bottom)
      $0.leading.trailing.bottom.equalToSuperview()
      
    }
    
  }
}

extension DonationView: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
    
    switch indexPath.row {
    case 0:
      cell.textLabel?.text = "에너지바"
      cell.imageView?.image = UIImage(named: "energybar")
      cell.imageView?.tintColor = UIColor.appColor(.appFontColor)
      cell.detailTextLabel?.text = "$0.99"
    case 1:
      cell.textLabel?.text = "커피"
      cell.imageView?.image = UIImage(named: "coffee")
      cell.imageView?.tintColor = UIColor.appColor(.appFontColor)
      cell.detailTextLabel?.text = "$4.99"
      
    case 2:
      cell.textLabel?.text = "버거세트"
      cell.imageView?.image = UIImage(named: "hamburger")
      cell.imageView?.tintColor = UIColor.appColor(.appFontColor)
      cell.detailTextLabel?.text = "$9.99"

    default:
      break
    }
    
    return cell
    
  }
  
  
}

extension DonationView: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UIScreen.main.bounds.height * 0.11
  }
}
