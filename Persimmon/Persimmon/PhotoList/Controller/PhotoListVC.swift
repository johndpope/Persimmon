//
//  PhotoListVC.swift
//  Persimmon
//
//  Created by Jeon-heaji on 2019/10/14.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit

class PhotoListVC: UIViewController {
  
  let photoListView = PhotoListView()
  let photoEmptyView = PhotoListViewEmpty()
  
  override func loadView() {
    self.view = photoListView
  }

    override func viewDidLoad() {
        super.viewDidLoad()
      
      view.backgroundColor = .white


    }
    


}
