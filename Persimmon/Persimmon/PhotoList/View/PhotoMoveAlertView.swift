//
//  PhotoMoveAlertView.swift
//  Persimmon
//
//  Created by Jeon-heaji on 2019/10/27.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import SnapKit

class PhotoMoveAlertView: UIView {

  let tableViewController = UITableViewController()
  
  let tableView = UITableView()
  
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    
    tableViewController.preferredContentSize = CGSize(width: 272, height: 176)
    
  }
  
  
}

extension PhotoMoveAlertView: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
    return cell
    
  }
  
}

extension PhotoMoveAlertView: UITableViewDelegate {
  
}
