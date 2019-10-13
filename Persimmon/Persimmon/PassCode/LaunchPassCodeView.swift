//
//  LaunchPassCodeView.swift
//  Persimmon
//
//  Created by Jeon-heaji on 2019/10/13.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit

class LaunchPassCodeView: UIView {
  
  let srcrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.alwaysBounceHorizontal = true
    scrollView.isPagingEnabled = true
    return scrollView
  }()

  let passCodeView = PassCodeView()
  
  let launchView = LaunchScreenView()
  
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    addSubviews()
       setupSNP()
  }
  
  private func addSubviews() {
    [srcrollView]
      .forEach { self.addSubview($0) }
    [launchView, passCodeView]
      .forEach { self.srcrollView.addSubview($0) }
  }
  
  private func setupSNP() {
    
//    let bounds = UIScreen.main.bounds
    
//    srcrollView.frame = CGRect(x: 0, y: 0, width: bounds.width * 2, height: bounds.height)
    
    srcrollView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()
    }
    
    launchView.snp.makeConstraints {
      $0.top.bottom.leading.equalTo(srcrollView)
      $0.width.height.equalToSuperview()
    }
    
    passCodeView.snp.makeConstraints {
      $0.top.trailing.bottom.equalTo(srcrollView)
      $0.leading.equalTo(launchView.snp.trailing)
      $0.width.height.equalToSuperview()
      
    }
    


  }
    



}
