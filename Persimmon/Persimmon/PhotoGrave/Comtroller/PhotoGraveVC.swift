//
//  PhotoGraveVC.swift
//  Persimmon
//
//  Created by hyeoktae kwon on 2019/10/23.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import Photos
import TLPhotoPicker
import RealmSwift

class PhotoGraveVC: UIViewController {
  let photoGraveView = PhotoGraveView()
  let object = RealmSingleton.shared.takeGrave()
  
  override func loadView() {
    self.view = photoGraveView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    print("viewDidAppear")
  }
  
  
}
