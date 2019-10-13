//
//  PassCodeVC.swift
//  Persimmon
//
//  Created by hyeoktae kwon on 2019/10/12.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit


class PassCodeVC: UIViewController {
  
  var isFirst: Bool = false
  let launchPassCodeView = LaunchPassCodeView()
  
  override func loadView() {
    self.view = launchPassCodeView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
  }
  
  

  
}
