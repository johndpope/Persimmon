//
//  SettingView.swift
//  Persimmon
//
//  Created by Jeon-heaji on 2019/10/16.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
protocol SettingViewDelegate {
  func tableCellDidTap(indexPath: IndexPath)
}

class SettingView: UIView {
  
  var delegate: SettingViewDelegate?
  
  private let passCodeData = [" 비밀번호 설정", " 사진 크기"]
  private let donationData = [" 기부하기"]
  
  let topView: UIView = {
    let topView = UIView()
    topView.backgroundColor = UIColor.appColor(.appLayerBorderColor)
    return topView
  }()
  
  let infoBtn: UIButton = {
    let button = UIButton(type: .custom)
    button.setImage(UIImage(named: "information"), for: .normal)
    button.tintColor = UIColor.appColor(.appGreenColor)
    return button
  }()
  
  let settingLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont(name: "NanumPen", size: 40)
    label.textColor = .appColor(.appFontColor)
    label.text = "설정"
    return label
  }()
  
  let secondView: UIView = {
    let sView = UIView()
    return sView
  }()
  
  lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.dataSource = self
    tableView.delegate = self
    return tableView
  }()
  

  lazy var persimmonImg: UIImageView = {
    let imageView = UIImageView()
    imageView.clipsToBounds = true
    imageView.contentMode = .scaleAspectFit
    imageView.image = UIImage(named: "PersimmonIconFalse")
    return imageView
  }()
  
  // 사진 밑에 들어갈 앨범이름
  let versionLabel: UILabel = {
    let label = UILabel()
    label.text = "단감 persimmon v1.0"
    label.font = UIFont(name: "NanumPen", size: 20)
    label.textColor = .appColor(.appGreenColor)
    return label
  }()
  
  let scaleBtn: UIButton = {
    let button = UIButton(type: .custom)
    button.setImage(UIImage(named: "PersimmonIconFalse"), for: .selected)
    button.setImage(UIImage(named: "PersimmonIconTrue"), for: .normal)
    let scale = UserDefaults.standard.bool(forKey: "scale")
    button.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
    button.isSelected = scale
//    button.tintColor = UIColor.appColor(.appGreenColor)
    return button
  }()
  
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    
    self.backgroundColor = .white
    addSubViews()
    setupSNP()
    setupTableView()
    
  }
  
   
    private func setupTableView() {
      tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
    }
    
  
  private func addSubViews() {
    [topView, secondView, tableView]
      .forEach { self.addSubview($0) }
    [infoBtn, settingLabel]
      .forEach { topView.addSubview($0) }
     [persimmonImg, versionLabel]
      .forEach { secondView.addSubview($0) }
  }
  
  private func setupSNP() {
    
    topView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.height.equalToSuperview().multipliedBy(0.22)
    }
    
    infoBtn.snp.makeConstraints {
      $0.top.equalTo(self.snp.topMargin).offset(10)
      $0.trailing.equalToSuperview().offset(-20)
      $0.width.height.equalTo(23)
    }
    
    secondView.snp.makeConstraints {
      $0.top.equalTo(topView.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalToSuperview().multipliedBy(0.23)
    }
    
    persimmonImg.snp.makeConstraints {
      $0.bottom.equalTo(versionLabel.snp.top).offset(-40)
      $0.centerX.equalToSuperview()
      $0.width.height.equalTo(secondView.snp.height).multipliedBy(0.35)
    }
    
    versionLabel.snp.makeConstraints {
      $0.bottom.equalTo(secondView.snp.bottom).offset(-10)
      $0.centerX.equalToSuperview()
    }
    
    settingLabel.snp.makeConstraints {
        $0.bottom.equalToSuperview().offset(-5)
        $0.leading.equalToSuperview().offset(30)
      }
    
    tableView.snp.makeConstraints {
      $0.leading.trailing.bottom.equalToSuperview()
      $0.top.equalTo(secondView.snp.bottom)
    }
    
  }

}
// MARK: - TableView Extensions

extension SettingView: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 3
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    switch section {
    case 0:
      return 1
    case 1:
      return passCodeData.count
    case 2:
      return donationData.count
//    case 3:
//      return 1
    default:
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    let footerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 2))
    footerView.backgroundColor = UIColor.appColor(.appGreenColor)
    return footerView
  }
  
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 2
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
    tableView.separatorStyle = .none
    
    switch indexPath.section {
    case 0:
      
      if indexPath.row == 0 {
        cell.imageView?.image = UIImage(named: "account")
        cell.imageView?.tintColor = UIColor.appColor(.appGreenColor)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = " 계정"
        cell.textLabel?.font = UIFont(name: "NanumPen", size: 20)
        cell.textLabel?.textColor = UIColor.appColor(.appGreenColor)
        cell.selectionStyle = .none
      }
    case 1:
      
      switch indexPath.row {
      case 0:
        cell.imageView?.image = UIImage(named: "login")
        cell.imageView?.tintColor = UIColor.appColor(.appGreenColor)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.font = UIFont(name: "NanumPen", size: 20)
        cell.textLabel?.text = passCodeData[indexPath.row]
        cell.textLabel?.textColor = UIColor.appColor(.appGreenColor)
        cell.selectionStyle = .none
      case 1:
        cell.imageView?.image = UIImage(named: "photoSize")
        cell.imageView?.tintColor = UIColor.appColor(.appGreenColor)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.font = UIFont(name: "NanumPen", size: 20)
        cell.textLabel?.text = passCodeData[indexPath.row]
        cell.textLabel?.textColor = UIColor.appColor(.appGreenColor)
        cell.accessoryView = scaleBtn
        cell.selectionStyle = .none
      default:
        break
      }
      
//      if indexPath.row == 0 {
//        cell.imageView?.image = UIImage(named: "login")
//        cell.imageView?.tintColor = UIColor.appColor(.appGreenColor)
//        cell.accessoryType = .disclosureIndicator
//        cell.textLabel?.font = UIFont(name: "NanumPen", size: 20)
//        cell.textLabel?.text = " 비밀번호 변경"
//        cell.textLabel?.textColor = UIColor.appColor(.appGreenColor)
//        cell.selectionStyle = .none
//      }
    case 2:
      
      if indexPath.row == 0 {
        cell.imageView?.image = UIImage(named: "donation")
        cell.imageView?.tintColor = UIColor.appColor(.appGreenColor)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = donationData[indexPath.row]
        cell.textLabel?.font = UIFont(name: "NanumPen", size: 20)
        cell.textLabel?.textColor = UIColor.appColor(.appGreenColor)
        cell.selectionStyle = .none
      }
      //    case 3:
      //      cell.textLabel?.text = ""
      
    default:
      break
    }
    return cell
    
  }
  
}

extension SettingView: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    delegate?.tableCellDidTap(indexPath: indexPath)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UIScreen.main.bounds.height * 0.08
  }
}
