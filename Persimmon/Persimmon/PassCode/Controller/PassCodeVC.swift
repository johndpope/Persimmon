//
//  PassCodeVC.swift
//  Persimmon
//
//  Created by hyeoktae kwon on 2019/10/12.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import LocalAuthentication


class PassCodeVC: UIViewController {
  
  var isFirst: Bool = false
  let launchPassCodeView = LaunchPassCodeView()
  
  let userDefaults = UserDefaults.standard
  
  var authorizationError: NSError?
  
  var prePassCode: String = ""
  var stackView: UIStackView {
    return launchPassCodeView.passCodeView.imageStackView
  }
  
  
  
  var text: String = "" {
    willSet {
      guard text.count < 4 else { return }
      stackView.arrangedSubviews[text.count].alpha = 1
    }
    didSet {
      print("현재 입력한 passcode: ", text)
      if text.count == 4 {
        if let saveCode = userDefaults.string(forKey: "pw") {
          if text == saveCode {
            // 넘어가기
            setupBiometric()
          } else {
            
            let alert = UIAlertController(title: "", message: "비밀번호가 틀립니다.", preferredStyle: .alert)
            
            let reInput = UIAlertAction(title: "확인", style: .default) { (action) in
              self.text = ""
              self.prePassCode = ""
              self.stackView.arrangedSubviews.forEach { (view) in
                view.alpha = 0.5
              }
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
              self.stackView.arrangedSubviews.forEach { (view) in
                view.alpha = 0.5
              }
            }
            let reInput = UIAlertAction(title: "다시하기", style: .default) { (action) in
              self.text = ""
              self.prePassCode = ""
              self.stackView.arrangedSubviews.forEach { (view) in
                view.alpha = 0.5
              }
            }
            alert.addAction(okAction)
            alert.addAction(reInput)
            present(alert, animated: true)
          } else {
            if prePassCode == text {
              // userdefaults 저장 -> 넘어가기
              userDefaults.setValue(text, forKey: "pw")
              
              setupBiometric(isRegi: true)
              
              print("이제 저장 후 넘어가기 해야함")
            } else {
              let alert = UIAlertController(title: "", message: "비밀번호가 틀립니다. 처음부터 다시하세요.", preferredStyle: .alert)
              
              let reInput = UIAlertAction(title: "확인", style: .default) { (action) in
                self.text = ""
                self.prePassCode = ""
                self.stackView.arrangedSubviews.forEach { (view) in
                  view.alpha = 0.5
                }
              }
              alert.addAction(reInput)
              present(alert, animated: true)
            }
          }
        }
        
        
      }
      
      
    }
    
  }
  
  private func setupBiometric(isRegi: Bool = false) {
//      guard self.model.viewState == .enter || self.model.viewState == .register2 else { return }
      
//      if self.model.viewState == .enter {
//        guard UserDefaults.standard.isBiometric else { return }
//      }
      
      let authContext = LAContext()
      
      if authContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &authorizationError) {
        authContext.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "생체인증 기능을 사용해요.") { (success, err) in
          if success {
            DispatchQueue.main.async {
              self.userDefaults.set(1, forKey: "bio")
              self.goNext()
            }
          } else {
            if let errorObj = err {
              let messageToDisplay = self.getErrorDescription(errorCode: errorObj._code)
              print("fail: ", messageToDisplay, errorObj._code)
              if errorObj._code == -6 && isRegi {
                DispatchQueue.main.async {
                  self.userDefaults.set(2, forKey: "bio")
                  self.goNext()
                }
              } else {
                print("when here?")
                let alert = UIAlertController(title: "", message: "생체인증 오류, 처음부터 다시하세요.", preferredStyle: .alert)
                
                let reInput = UIAlertAction(title: "확인", style: .default) { (action) in
                  if isRegi {
                    self.userDefaults.removeObject(forKey: "pw")
                  }
                  self.text = ""
                  self.prePassCode = ""
                  self.stackView.arrangedSubviews.forEach { (view) in
                    view.alpha = 0.5
                  }
                }
                alert.addAction(reInput)
                DispatchQueue.main.async {
                  self.present(alert, animated: true)
                }
              }
            }
          }
        }
      } else {
        print("when? here???")
        if isRegi {
          DispatchQueue.main.async {
            self.userDefaults.set(2, forKey: "bio")
            self.goNext()
          }
        } else {
          let bio = self.userDefaults.integer(forKey: "bio")
          guard bio != 1 else {
            DispatchQueue.main.async {
              Isaac.toast("앱 설정에서 페이스아이디를 사용해야해요.")
              self.text = ""
              self.prePassCode = ""
              self.stackView.arrangedSubviews.forEach { (view) in
                view.alpha = 0.5
              }
            }
            return }
          DispatchQueue.main.async {
            self.userDefaults.set(2, forKey: "bio")
            self.goNext()
          }
        }
    }
    }
  
  private func goNext() {
    let vc = MainTabBarController()
    let navi = UINavigationController(rootViewController: vc)
    navi.modalPresentationStyle = .fullScreen
    navi.modalTransitionStyle = .crossDissolve
    navi.navigationBar.isHidden = true
    self.present(navi, animated: true)
  }
  
  
  override func loadView() {
    self.view = launchPassCodeView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    launchPassCodeView.passCodeView.delegate = self
    launchPassCodeView.passCodeView.deleteBtn.addTarget(self, action: #selector(deleteBtnTapped(_:)), for: .touchUpInside)
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    guard userDefaults.string(forKey: "pw") == nil else { return }
    
    UIAlertController().makeAlert(title: "비밀번호", mesage: "오른쪽으로 스와이프하여 초기비밀번호를 만들어주세요.", actionTitle: "네", vc: self) {_ in}
  }
  
  // text <- delete
  @objc func deleteBtnTapped(_ sender: UIButton) {
    if text.isEmpty {
      print("delete")
    } else {
      text.removeLast()
    }
  }
  
  private func getErrorDescription(errorCode: Int) -> String {
  
     switch errorCode {
         
     case LAError.authenticationFailed.rawValue:
         return "Authentication was not successful, because user failed to provide valid credentials."
         
     case LAError.appCancel.rawValue:
         return "Authentication was canceled by application (e.g. invalidate was called while authentication was in progress)."
         
     case LAError.invalidContext.rawValue:
         return "LAContext passed to this call has been previously invalidated."
         
     case LAError.notInteractive.rawValue:
         return "Authentication failed, because it would require showing UI which has been forbidden by using interactionNotAllowed property."
         
     case LAError.passcodeNotSet.rawValue:
         return "Authentication could not start, because passcode is not set on the device."
         
     case LAError.systemCancel.rawValue:
         return "Authentication was canceled by system (e.g. another application went to foreground)."
         
     case LAError.userCancel.rawValue:
         return "Authentication was canceled by user (e.g. tapped Cancel button)."
         
     case LAError.userFallback.rawValue:
         return "Authentication was canceled, because the user tapped the fallback button (Enter Password)."
         
     default:
         return "Error code \(errorCode) not found"
     }
     
  }
  
}



extension PassCodeVC: PassCodeViewDelegate {
  func didTapButton(input: String) {
    text.append(input)
  }
  
}
