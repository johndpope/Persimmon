//
//  SelectAlbumVC.swift
//  Persimmon
//
//  Created by Jeon-heaji on 2019/10/14.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit

class SelectAlbumVC: UIViewController {
  
  let selectAlbumView = SelectAlbumView()
  
  override func loadView() {
    self.view = selectAlbumView
  }

    override func viewDidLoad() {
        super.viewDidLoad()
      
      selectAlbumView.backBtn.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)

        
    }
  
  @objc func didTapButton(_ sender: UIButton) {
    dismiss(animated: true)
  }
    

   

}
