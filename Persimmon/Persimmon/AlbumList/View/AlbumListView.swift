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

extension AlbumListView: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return albums.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: AlbumListTableCell.identifier, for: indexPath) as! AlbumListTableCell
    cell.titleLabel.text = albums[indexPath.row].title
    cell.subTitleLabel.text = "[ \(albums[indexPath.row].photos.count.description) ]"
    cell.albumImageView.contentMode = .scaleAspectFill
    cell.albumImageView.image = UIImage(data: albums[indexPath.row].photos.last?.photoData ?? Data())
    cell.selectionStyle = .none
    return cell
  }
  
  
}

extension AlbumListView: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UIScreen.main.bounds.height * 0.13
  }
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return UIScreen.main.bounds.height * 0.10
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let uuid = albums[indexPath.row].uuid
    delegate?.didSelectCell(indexPath: self, uuid: uuid)
  }
  
  func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
  
    
    let deleteAction = UIContextualAction(style: .normal, title: nil) { (UIContextualAction, UIView,  success: (Bool) -> Void) in
      // 삭제버튼
      success(true)
    }
    
    deleteAction.image = UIImage(named: "delete")
    deleteAction.backgroundColor = .white
    
    

    let editAction = UIContextualAction(style: .normal, title: nil) { (UIContextualAction, UIView, success: (Bool) -> Void) in
      // 수정버튼
      success(true)
    }
    editAction.image = UIImage(named: "modification")
    editAction.backgroundColor = .white

    return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
  }
  
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      
      print("editing")
    }
  }
  

}
