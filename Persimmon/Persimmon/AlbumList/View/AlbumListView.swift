//
//  AlbumListView.swift
//  Persimmon
//
//  Created by Jeon-heaji on 2019/10/14.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import SnapKit
import RealmSwift
import TLPhotoPicker

class AlbumListView: UIView {
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
    return button
  }()
  
  lazy var addBtn: UIButton = {
    let button = UIButton(type: .custom)
    button.titleLabel?.font = UIFont(name: "NanumPen", size: 20)
    button.setTitle("추가", for: .normal)
    button.setTitleColor(.appColor(.appFontColor), for: .normal)
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
    tableView.separatorStyle = .none
    return tableView
  }()
  
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    addSubViews()
    setupSNP()
    setupTableView()
    
  }
 
  private func setupTableView() {
    tableView.register(AlbumListTableCell.self, forCellReuseIdentifier: AlbumListTableCell.identifier)

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
      $0.height.equalToSuperview().multipliedBy(0.22)
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




