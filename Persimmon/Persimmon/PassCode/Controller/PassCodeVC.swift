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
  let passCodeView = PassCodeView()
  
  let userDefaults = UserDefaults.standard
  
  var prePassCode: String = ""
  
  var persimmonIcon = UIImage(named: "PasscodeIcon")
  
  
  
  var text: String = "" {
    didSet {
      print("현재 입력한 passcode: ", text)

      if text.count == 4 {
        if let saveCode = userDefaults.string(forKey: "pw") {
          if text == saveCode {
            // 넘어가기
            let vc = MainTabBarController()
            let navi = UINavigationController(rootViewController: vc)
            navi.modalPresentationStyle = .fullScreen
            navi.modalTransitionStyle = .crossDissolve
            navi.navigationBar.isHidden = true
            self.present(navi, animated: true)
            
            print("넘어가라")
          } else {
            let alert = UIAlertController(title: "", message: "비밀번호가 틀립니다.", preferredStyle: .alert)
            
            let reInput = UIAlertAction(title: "확인", style: .default) { (action) in
              self.text = ""
              self.prePassCode = ""
            }
            alert.addAction(reInput)
            present(alert, animated: true)
            
          }
          
          
        } else { // 초기
          if prePassCode == "" {
            let alert = UIAlertController(title: "", message: "현재 비밀번호: \(text)", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "저장", style: .default) { (action) in
              self.prePassCode = self.text
              self.text = ""
            }
            let reInput = UIAlertAction(title: "다시하기", style: .default) { (action) in
              self.text = ""
              self.prePassCode = ""
            }
            alert.addAction(okAction)
            alert.addAction(reInput)
            present(alert, animated: true)
          } else {
            if prePassCode == text {
              // userdefaults 저장 -> 넘어가기
              userDefaults.setValue(text, forKey: "pw")
              let vc = MainTabBarController()
              let navi = UINavigationController(rootViewController: vc)
              navi.modalPresentationStyle = .fullScreen
              navi.modalTransitionStyle = .crossDissolve
              navi.navigationBar.isHidden = true
              self.present(navi, animated: true)
              
              
              print("이제 저장 후 넘어가기 해야함")
            } else {
              let alert = UIAlertController(title: "", message: "비밀번호가 틀립니다. 처음부터 다시하세요.", preferredStyle: .alert)
              
              let reInput = UIAlertAction(title: "확인", style: .default) { (action) in
                self.text = ""
                self.prePassCode = ""
              }
              alert.addAction(reInput)
              present(alert, animated: true)
            }
          }
        }
        
        
      }
      
      
    }
    
  }
  
  
  override func loadView() {
    self.view = launchPassCodeView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    launchPassCodeView.passCodeView.delegate = self
    launchPassCodeView.passCodeView.deleteBtn.addTarget(self, action: #selector(deleteBtnTapped(_:)), for: .touchUpInside)
    
  }
  
  // text <- delete
  @objc func deleteBtnTapped(_ sender: UIButton) {
    if text.isEmpty {
      print("delete")
    } else {
      text.removeLast()
      
 
    }
    
  }
  
}



extension PassCodeVC: PassCodeViewDelegate {
  func didTapButton(input: String) {
    print(passCodeView.imageStackView.arrangedSubviews.count)
    text.append(input)
    print("passcode alpha", passCodeView.imageStackView.alpha)
    
  }
  
}
