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
//      AppDelegate.instance.albumListState()
      
    }
  private func setupNavi() {
    navigationController?.title = "사진첩"
    
  }
    

}
