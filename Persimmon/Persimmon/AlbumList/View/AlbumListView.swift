//
//  AlbumListView.swift
//  Persimmon
//
//  Created by Jeon-heaji on 2019/10/14.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import SnapKit
import TLPhotoPicker

protocol AlbumListViewDelegate {
  func didSelectCell(indexPath: AlbumListView)
}

class AlbumListView: UIView {
  
  var delegate: AlbumListViewDelegate?
  
  let topView: UIView = {
    let topView = UIView()
    topView.backgroundColor = UIColor.appColor(.appLayerBorderColor)
    return topView
  }()
  
  lazy var editBtn: UIButton = {
    let button = UIButton(type: .custom)
    button.titleLabel?.font = UIFont(name: "NanumPen", size: 20)
    button.setTitle("수정", for: .normal)
    button.setTitleColor(.appColor(.appFontColor), for: .normal)
    button.addTarget(self, action: #selector(editBtndidTap(_:)), for: .touchUpInside)
    return button
  }()
  
  lazy var addBtn: UIButton = {
    let button = UIButton(type: .custom)
    button.titleLabel?.font = UIFont(name: "NanumPen", size: 20)
    button.setTitle("추가", for: .normal)
    button.setTitleColor(.appColor(.appFontColor), for: .normal)
    button.addTarget(self, action: #selector(addBtndidTap(_:)), for: .touchUpInside)
    return button
  }()

  lazy var albumLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont(name: "NanumPen", size: 40)
    label.textColor = .appColor(.appFontColor)
    label.text = "사진첩"
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
    
    addSubViews()
    setupSNP()
    setupTableView()
    
  }
  
  // MARK: - 수정, 추가 버튼 연결 - VC
  @objc func editBtndidTap(_ sender: UIButton) {
     print("수정버튼")
   }
  
  @objc func addBtndidTap(_ sender: UIButton) {
    print("추가버튼")
  }
  
  func bundle() -> Bundle {
      let podBundle = Bundle(for: TLBundle.self)
      if let url = podBundle.url(forResource: "TLPhotoPicker", withExtension: "bundle") {
          let bundle = Bundle(url: url)
          return bundle ?? podBundle
      }
      return podBundle
  }
  
  
  private func setupTableView() {
    tableView.register(UINib(nibName: "TLCollectionTableViewCell", bundle: bundle()), forCellReuseIdentifier: "TLCollectionTableViewCell")
//    tableView.register(TLCollectionTableViewCell.self, forCellReuseIdentifier: "TLCollectionTableViewCell")
  }
  
  private func addSubViews() {
    [topView, tableView]
      .forEach { self.addSubview($0) }
    [editBtn, addBtn, albumLabel]
      .forEach { topView.addSubview($0) }
  }
  
  private func setupSNP() {
    
    topView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.height.equalToSuperview().multipliedBy(0.23)
    }
    
    editBtn.snp.makeConstraints {
      $0.top.equalTo(self.snp.topMargin).offset(10)
      $0.leading.equalToSuperview().offset(30)
    }
    
    addBtn.snp.makeConstraints {
      $0.top.equalTo(self.snp.topMargin).offset(10)
      $0.trailing.equalToSuperview().offset(-30)
    }
    
    albumLabel.snp.makeConstraints {
      $0.bottom.equalToSuperview().offset(-5)
      $0.leading.equalToSuperview().offset(30)
    }
    
    tableView.snp.makeConstraints {
      $0.leading.trailing.bottom.equalToSuperview()
      $0.top.equalTo(topView.snp.bottom)
    }
    
  }

  
}

extension AlbumListView: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    tableView.separatorStyle = .none
//    switch indexPath.row {
//    case 0:
//      let cell = tableView.dequeueReusableCell(withIdentifier: "TLCollectionTableViewCell", for: indexPath) as! TLCollectionTableViewCell
//      cell.titleLabel.text = "123"
//      cell.selectionStyle = .none
//      return cell
//    default:
//      let cell = UITableViewCell()
//      cell.selectionStyle = .none
//      return cell
//    }
//
    let cell = tableView.dequeueReusableCell(withIdentifier: "TLCollectionTableViewCell", for: indexPath) as! TLCollectionTableViewCell
      cell.titleLabel.text = "123"
      cell.selectionStyle = .none
      return cell
  }
  
  
}

extension AlbumListView: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UIScreen.main.bounds.height * 0.15
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    delegate?.didSelectCell(indexPath: self)
  }
}
