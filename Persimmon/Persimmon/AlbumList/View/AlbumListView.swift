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
    return topView
  }()
  
  let editLabel: UILabel = {
    let label = UILabel()
    label.text = "수정"
    label.textColor = .appColor(.appFontColor)
    label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
//    label.font = UIFont(name: "Palatino", size: 17)
    return label
  }()
  
  let persimmonBtn: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "persimmonicon1"), for: .normal)
    return button
  }()

  lazy var albumLabel: UILabel = {
    let label = UILabel()
    label.text = "사진첩"
    label.textColor = .appColor(.appFontColor)
    label.adjustsFontForContentSizeCategory = true
    label.font = UIFont(name: "Optima", size: 35)
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
    [editLabel, persimmonBtn, albumLabel]
      .forEach { topView.addSubview($0) }
  }
  
  private func setupSNP() {
    
    topView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.height.equalTo(UIScreen.main.bounds.height / 5)
    }
    
    editLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(UIScreen.main.bounds.height * 0.07)
      $0.leading.equalToSuperview().inset(30)
    }
    
    persimmonBtn.snp.makeConstraints {
      $0.top.equalTo(UIScreen.main.bounds.height * 0.07)
      $0.trailing.equalToSuperview().inset(30)
    }
    
    albumLabel.snp.makeConstraints {
      $0.top.equalTo(editLabel.snp.bottom).offset(40)
      $0.leading.equalToSuperview().inset(30)
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
    switch indexPath.row {
    case 0:
      let cell = tableView.dequeueReusableCell(withIdentifier: "TLCollectionTableViewCell", for: indexPath) as! TLCollectionTableViewCell
      cell.titleLabel.text = "123"
      cell.selectionStyle = .none
      return cell
    default:
      let cell = UITableViewCell()
      cell.selectionStyle = .none
      return cell
    }
  }
  
  
}

extension AlbumListView: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UIScreen.main.bounds.height * 0.10
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    delegate?.didSelectCell(indexPath: self)
  }
}


