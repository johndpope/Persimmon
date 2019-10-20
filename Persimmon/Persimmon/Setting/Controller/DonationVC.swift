//
//  DonationVC.swift
//  Persimmon
//
//  Created by Jeon-heaji on 2019/10/20.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit

class DonationVC: UIViewController {
  
  let donationView = DonationView()

    override func viewDidLoad() {
        super.viewDidLoad()
      self.view = donationView
      donationView.backBtn.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)


      

    }
  
  @objc func didTapButton(_ sender: UIButton) {
    navigationController?.popViewController(animated: true)
  }
  

    
}
