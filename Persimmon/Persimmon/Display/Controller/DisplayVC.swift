//
//  DisplayVC.swift
//  Persimmon
//
//  Created by hyeoktae kwon on 2019/11/02.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit

class DisplayVC: UIViewController {
  
  let displayView: DisplayView = {
    let view = DisplayView()
    view.bottomView.graveBtn.addTarget(self, action: #selector(didTapGraveBtn(_:)), for: .touchUpInside)
    view.bottomView.playBtn.addTarget(self, action: #selector(didTapPlayBtn(_:)), for: .touchUpInside)
    view.bottomView.muteBtn.addTarget(self, action: #selector(didTapMuteBtn(_:)), for: .touchUpInside)
    view.topView.backBtn.addTarget(self, action: #selector(<#T##@objc method#>), for: <#T##UIControl.Event#>)
    return view
  }()
  
  override func loadView() {
    self.view = displayView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  @objc func didTapGraveBtn(_ sender: UIButton) {
    
  }
  
  @objc func didTapSharedBtn(_ sender: UIButton) {
    
  }
  
  @objc func didTapPlayBtn(_ sender: UIButton) {
    
  }
  
  @objc func didTapMuteBtn(_ sender: UIButton) {
    
  }
  
  @objc func didTapBackBtn(_ sender: UIButton) {
    
  }
  
}
