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
  
  override func loadView() {
    self.view = albumListView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    albumListView.delegate = self
    albumListView.addBtn.addTarget(self, action: #selector(didTapAddBtn(_:)), for: .touchUpInside)
    
    notificationToken = RealmSingleton.shared.realm.observe({ (noti, realm) in
      DispatchQueue.main.async {
        self.albumListView.tableView.reloadData()
      }
    })
    
    albumListView.editBtn.addTarget(self, action: #selector(editBtnDidTap(_:)), for: .touchUpInside)
    navigationItem.leftBarButtonItem = editButtonItem

  }
  @objc func editBtnDidTap(_ sender: UIButton) {
    
   }
   
  
  deinit {
    notificationToken?.invalidate()
  }
  
  private func setupNavi() {
    
  }
  
  @objc func didTapAddBtn(_ sender: UIButton) {
    //1. 알림창을 경고 형식으로 정의 한다.
    
    let alert = UIAlertController(title: nil, message: "새 앨범 만들기",preferredStyle: .alert)
    
    //2. add textfield
    alert.addTextField()
    alert.textFields?.first?.placeholder = "새 앨범"
    //3. 버튼을 정의 한다.
    
    let cameraAction = UIAlertAction(title: "만들기", style: .default) { (_) -> Void in
      let text = alert.textFields?.first?.text
      RealmSingleton.shared.addAlbum(title: text)
    }
    
    let cancelAction = UIAlertAction(title: "취소", style: .cancel)
    //4. 정의된 버튼을 알림창 객체에 추가한다.
    
    
    alert.addAction(cameraAction)
    alert.addAction(cancelAction)
    let contentVC = CustomAlertVC()
    alert.view.tintColor = UIColor.appColor(.appGreenColor)
    // 뷰 컨트롤러 알림창의 콘텐츠 뷰 컨트롤러 속성에 등록한다.
    
    alert.setValue(contentVC, forKeyPath: "contentViewController")
    
    //4. 알림창을 화면에 표시한다.
    
    self.present(alert, animated: true)
    
  }
  
}

extension AlbumListVC: AlbumListViewDelegate {
  func didSelectCell(indexPath: AlbumListView, uuid: String) {
    
    DispatchQueue.main.async { [weak self] in
      guard let `self` = self else { return }
      let photoListVC = PhotoListVC()
      photoListVC.uuid = uuid
      self.navigationController?.pushViewController(photoListVC, animated: true)
    }
    
  }
  
  
}
