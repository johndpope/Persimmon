//
//  PassCodeSetVC.swift
//  Persimmon
//
//  Created by Jeon-heaji on 2019/10/16.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit

class ChangePassCodeVC: UIViewController {
  
  let passCodeView = PassCodeView()
  let userDefaults = UserDefaults.standard
  
  var prePassCode = ""
  var isPassCodeIn = false
  
  var text: String = "" {
    didSet {
      print("현재 입력한 passcode: ", text)
      if isPassCodeIn {
        
      }
      
      if text.count == 4 {
        if let savePassCode = userDefaults.string(forKey: "pw") {
          if text == savePassCode {
            // 한번더 확인
            print("확인")
            self.prePassCode = self.text
            self.text = ""
            
            let alert = UIAlertController(title: "", message: "한번 더 비밀번호를 입력하세요.", preferredStyle: .alert)
            
            let reInput = UIAlertAction(title: "확인", style: .default) { (action) in
              if self.text == self.prePassCode {
                // 한번 더 확인
                print("한번 더 확인함")
                self.prePassCode = self.text
                self.text = ""
              }
            }
            alert.addAction(reInput)
            present(alert, animated: true)
            
            
          } else {
            let alert = UIAlertController(title: "", message: "비밀번호가 틀립니다.", preferredStyle: .alert)
            
            let reInput = UIAlertAction(title: "확인", style: .default) { (action) in
              self.text = ""
              self.prePassCode = ""
              
            }
            alert.addAction(reInput)
            present(alert, animated: true)
          }
        }
      }
      
//      let alert = UIAlertController(title: "", message: "초기 비밀번호를 입력하세요.", preferredStyle: .alert)
//
//      let reInput = UIAlertAction(title: "확인", style: .default)
//      alert.addAction(reInput)
//      present(alert, animated: true)
      
      if let earlyPassCode = self.userDefaults.string(forKey: "pw") {
        if text == earlyPassCode {
          let alert = UIAlertController(title: "", message: "비밀번호가 맞습니다.", preferredStyle: .alert)
          
          let reInput = UIAlertAction(title: "확인", style: .default)
          alert.addAction(reInput)
          present(alert, animated: true)
          
          
//          if text.count == 4 {
//            if let savePassCode = userDefaults.string(forKey: "pw") {
//              if text == savePassCode {
//                // 한번더 확인
//                print("한번 더 확인")
//                let alert = UIAlertController(title: "", message: "한번 더 비밀번호를 입력하세요.", preferredStyle: .alert)
//
//                let reInput = UIAlertAction(title: "확인", style: .default) { (action) in
//                  // 넘어가요
//                  print("이제 넘어가요")
//
//                }
//                alert.addAction(reInput)
//                present(alert, animated: true)
//              } else {
//                let alert = UIAlertController(title: "", message: "비밀번호가 틀립니다.", preferredStyle: .alert)
//
//                let reInput = UIAlertAction(title: "확인", style: .default) { (action) in
//                  self.text = ""
//                  self.prePassCode = ""
//
//                }
//                alert.addAction(reInput)
//                present(alert, animated: true)
//              }
//            }
//          }
        } else {
//          let alert = UIAlertController(title: "", message: "비밀번호가 틀립니다.", preferredStyle: .alert)
//
//          let reInput = UIAlertAction(title: "확인", style: .default) { (action) in
//            self.text = ""
//            self.prePassCode = ""
//          }
//          alert.addAction(reInput)
//                        present(alert, animated: true)
        }
      }
    }
  }
  
  
  override func loadView() {
    self.view = passCodeView
    passCodeView.delegate = self
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
  }
  
  
}

extension ChangePassCodeVC: PassCodeViewDelegate {
  func didTapButton(input: String) {
    text.append(input)
  }
  
  
}
