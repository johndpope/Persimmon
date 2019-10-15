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

protocol AlbumListViewDelegate {
  func didSelectCell(indexPath: AlbumListView, uuid: String)
}

class AlbumListView: UIView {
  
  var delegate: AlbumListViewDelegate?
  
  var albums = RealmSingleton.shared.realm.objects(Album.self)
  
  let topView: UIView = {
    let topView = UIView()
    return topView
  }()
  
  let editBtn: UIButton = {
    let button = UIButton(type: .custom)
    button.titleLabel?.font = UIFont(name: "NanumPen", size: 17)
    button.setTitle("수정", for: .normal)
    button.setTitleColor(.appColor(.appFontColor), for: .normal)
    
//    label.font = UIFont(name: "Palatino", size: 17)
    return button
  }()
  
  let addBtn: UIButton = {
    let button = UIButton(type: .custom)
//    button.setImage(UIImage(named: "persimmonIPassCodeIcon"), for: .normal)
    button.titleLabel?.font = UIFont(name: "NanumPen", size: 17)
    button.setTitle("추가", for: .normal)
    button.setTitleColor(.appColor(.appFontColor), for: .normal)
    return button
  }()
  
  lazy var albumLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont(name: "NanumPen", size: 30)
    label.textColor = .appColor(.appFontColor)
//    label.adjustsFontForContentSizeCategory = true
    label.text = "사진첩"
    return label
  }()
  
  
  lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.dataSource = self
    tableView.delegate = self
    return tableView
  }()
  
  lazy var selectToken = RealmSingleton.shared.selectAlbum?.observe { (change) in
//    guard let `self` = self else { return }
    switch change {
    case .change(_):
      print("changed")
      self.tableView.reloadData()
    case .deleted:
      print("deleted")
      self.tableView.reloadData()
    case .error(let err):
      print("err: ", err)
    }
  }
  
  lazy var token = RealmSingleton.shared.selectAlbum?.observe { (change) in
  //    guard let `self` = self else { return }
      switch change {
      case .change(_):
        print("initial")
        self.tableView.reloadData()
      case .deleted:
        print("update")
        self.tableView.reloadData()
      case .error(let err):
        print("err: ", err)
      }
    }
  
//  deinit {
//    selectToken?.invalidate()
//  }
  
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    
    addSubViews()
    setupSNP()
    setupTableView()
    
  }
  
  private func setupTableView() {
    
    tableView.register(UINib(nibName: "TLCollectionTableViewCell", bundle: Bundle().bundle()), forCellReuseIdentifier: "TLCollectionTableViewCell")
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
      $0.height.equalToSuperview().multipliedBy(0.3)
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
      $0.top.equalTo(editBtn.snp.bottom).offset(40)
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
    return albums.count
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
    cell.titleLabel.text = albums[indexPath.row].title
    cell.subTitleLabel.text = albums[indexPath.row].photos.count.description
    cell.imageView?.contentMode = .scaleAspectFill
    cell.imageView?.image = UIImage(data: albums[indexPath.row].photos.last?.photoData ?? Data())
    cell.selectionStyle = .none
    return cell
  }
  
  
}

extension AlbumListView: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UIScreen.main.bounds.height * 0.10
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let uuid = albums[indexPath.row].uuid
    delegate?.didSelectCell(indexPath: self, uuid: uuid)
  }
}
