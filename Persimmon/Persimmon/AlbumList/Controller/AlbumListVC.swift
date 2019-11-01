//
//  AlbumListVC.swift
//  Persimmon
//
//  Created by Jeon-heaji on 2019/10/14.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import RealmSwift

class AlbumListVC: UIViewController {
  
  var notificationToken: NotificationToken? = nil
  
  let albumListView = AlbumListView()
  
  var albums = RealmSingleton.shared.realm.objects(Album.self)
  
  var action = false
  
  var tableView: UITableView {
    return albumListView.tableView
  }
  
  override func loadView() {
    self.view = albumListView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    tableView.delegate = self
    tableView.dataSource = self
    albumListView.addBtn.addTarget(self, action: #selector(didTapAddBtn(_:)), for: .touchUpInside)
    
    notificationToken = RealmSingleton.shared.realm.observe({ [weak self] (noti, realm) in
      guard let `self` = self else { return }
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    })
    
    albumListView.editBtn.addTarget(self, action: #selector(editBtnDidTap(_:)), for: .touchUpInside)
    navigationItem.leftBarButtonItem = editButtonItem
    
  }
  @objc func editBtnDidTap(_ sender: UIButton) {
    UIAlertController().makeAlert(title: "수정", mesage: "앨범을 왼쪽에서 오른쪽으로 스와이프하면 수정가능합니다.", actionTitle: "네", vc: self) { (_) in }
  }
  
  
  deinit {
    notificationToken?.invalidate()
  }
  
  private func setupNavi() {
    
  }
  
  @objc func didTapAddBtn(_ sender: UIButton) {
    //1. 알림창을 경고 형식으로 정의 한다.
    
    UIAlertController().makeTextFieldAlert(title: nil, mesage: "새 앨범 만들기", actionTitle: "만들기", vc: self) { (result) in
      switch result {
      case .success(let text):
        RealmSingleton.shared.addAlbum(title: text)
      case .failure(_):
        break
      }
    }
    
  }
  
}


extension AlbumListVC: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return albums.count
    
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    tableView.separatorStyle = .singleLine
    let cell = tableView.dequeueReusableCell(withIdentifier: AlbumListTableCell.identifier, for: indexPath) as! AlbumListTableCell
    cell.selectionStyle = .none
    cell.titleLabel.text = albums[indexPath.row].title
    cell.subTitleLabel.text = "[ \(albums[indexPath.row].photos.count.description) ]"
    cell.albumImageView.contentMode = .scaleAspectFill
    cell.albumUUID = albums[indexPath.row].albumUUID
    
    guard let lastPhoto = albums[indexPath.row].photos.last,
      let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first,
      let imageData = try? Data(contentsOf: url.appendingPathComponent("\(lastPhoto.photoUUID)/\(lastPhoto.thumbnail)")) else {
        cell.albumImageView.image = UIImage(named: "persimmonIcon")
        return cell
        
    }
    
    cell.albumImageView.image = UIImage(data: imageData)
    return cell
  }
  
  
}


extension AlbumListVC: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UIScreen.main.bounds.height * 0.13
    
  }
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return UIScreen.main.bounds.height * 0.10
    
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let uuid = albums[indexPath.row].albumUUID
    didSelectCell(uuid: uuid)
  }
  
  func didSelectCell(uuid: String) {
    DispatchQueue.main.async { [weak self] in
      guard let `self` = self else { return }
      let photoListVC = PhotoListVC()
      photoListVC.uuid = uuid
      self.navigationController?.pushViewController(photoListVC, animated: true)
    }
    
  }
  
  func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let deleteAction = UIContextualAction(style: .normal, title: nil) { (UIContextualAction, UIView,  success: @escaping (Bool) -> Void) in
      // 삭제버튼
      UIAlertController().makeAlert(title: "앨범삭제", mesage: "앨범에 있는 사진 또한 영구적으로 삭제 됩니다.", actionTitle: "삭제", vc: self) { (state) in
        if state {
          var photoUUIDs: [String] = []
          let uuid = self.albums[indexPath.row].albumUUID
          self.albums[indexPath.row].photos.forEach { (photo) in
            photoUUIDs.append(photo.photoUUID)
          }
          TassPhoto().deletePhotos(photoUUIDs: photoUUIDs)
          RealmSingleton.shared.deleteAlbum(albumUUID: uuid)
          success(true)
        } else {
          success(false)
        }
      }
      
    }
    
    deleteAction.image = UIImage(named: "delete")
    deleteAction.backgroundColor = .white
    
    let editAction = UIContextualAction(style: .normal, title: nil) { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
      UIAlertController().makeTextFieldAlert(title: nil, mesage: "앨범 타이틀 수정", actionTitle: "수정", vc: self) { (result) in
        switch result {
        case .success(let text):
          let uuid = self.albums[indexPath.row].albumUUID
          RealmSingleton.shared.changeAlbumTitle(title: text, albumUUID: uuid)
          success(true)
        case .failure(_):
          success(false)
          break
        }
      }
    }
    
    editAction.image = UIImage(named: "modification")
    editAction.backgroundColor = .white
    
    return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    
  }
  
  
//  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//    if editingStyle == .insert {
//      print("editing")
//    }
//
//  }
  

}
