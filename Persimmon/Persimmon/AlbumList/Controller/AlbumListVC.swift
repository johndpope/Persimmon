//
//  AlbumListVC.swift
//  Persimmon
//
//  Created by Jeon-heaji on 2019/10/14.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit


class AlbumListVC: UIViewController {
  
  
  let albumListView = AlbumListView()
  
  override func loadView() {
    self.view = albumListView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    albumListView.delegate = self
//    RealmSingleton.shared.addAlbum(title: "좀 나와라")
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    albumListView.tableView.reloadData()
  }
  
  private func setupNavi() {
    
    
  }
  
}

extension AlbumListVC: AlbumListViewDelegate {
  func didSelectCell(indexPath: AlbumListView, uuid: String) {
    let photoListVC = PhotoListVC()
    photoListVC.uuid = uuid
    print("push")
    navigationController?.pushViewController(photoListVC, animated: true)
  }
  
  
}
