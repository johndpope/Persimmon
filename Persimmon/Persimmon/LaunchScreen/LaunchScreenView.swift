//
//  LaunchScreenVC.swift
//  Persimmon
//
//  Created by Jeon-heaji on 2019/10/13.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit

class LaunchScreenView: UIView {
  
  let launchImageView: UIImageView = {
    let img = UIImageView()
    img.image = UIImage(named: "persimmonbackBig")
    img.contentMode = .scaleToFill
    img.clipsToBounds = true
    return img
  }()
  
  let launchlogoImageView: UIImageView = {
    let img = UIImageView()
    img.image = UIImage(named: "persimmonLogo")
    img.contentMode = .scaleAspectFit
    img.clipsToBounds = true
    return img
  }()


  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    addSubviews()
       setupSNP()

  }
  
   
  private func addSubviews() {
    [launchImageView,launchlogoImageView]
      .forEach { self.addSubview($0) }
  }
  
  private func setupSNP() {
    launchImageView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()
    }
    
//    launchlogoImageView.snp.makeConstraints {
//      $0.centerX.equalToSuperview().multipliedBy(1.5)
//      $0.centerY.equalToSuperview().multipliedBy(0.45)
//      $0.width.height.equalTo(130)
//    }
  }
    



}
