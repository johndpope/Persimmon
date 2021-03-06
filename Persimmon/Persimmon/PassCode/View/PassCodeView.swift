//
//  PassCodeView.swift
//  Persimmon
//
//  Created by hyeoktae kwon on 2019/10/12.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import SnapKit

protocol PassCodeViewDelegate: class {
  func didTapButton(input: String)
}

class PassCodeView: UIView {
  
  weak var delegate: PassCodeViewDelegate?
  
  private var firstStackView = UIStackView()
  private var secondStackView = UIStackView()
  private var thirdStackView = UIStackView()
  lazy var imageStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [passcode1, passcode2, passcode3, passcode4])
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    stackView.spacing = 5
    return stackView
  }()
  
  
  let imageView: UIImageView = {
    let img = UIImageView()
    img.image = UIDevice.current.hasNotch ?
      UIImage(named: "persimmonPassCodeBig") : UIImage(named: "persimmonPassCodeSmall")
    img.contentMode = .scaleToFill
    img.clipsToBounds = true
    return img
  }()
  
//  let logoImageView: UIImageView = {
//    let img = UIImageView()
//    img.image = UIImage(named: "persimmonLogo")
//    img.contentMode = .scaleAspectFit
//    img.clipsToBounds = true
//    return img
//  }()
//
  
  let passcode1: UIImageView = {
    let view = UIImageView()
    view.image = UIImage(named: "PasscodeIcon")
    view.alpha = 0.5
    return view
  }()
  
  let passcode2: UIButton = {
    let button = UIButton(type: .custom)
    button.setImage(UIImage(named: "PasscodeIcon"), for: .normal)
    button.alpha = 0.5
    return button
  }()
  
  let passcode3: UIButton = {
    let button = UIButton(type: .custom)
    button.setImage(UIImage(named: "PasscodeIcon"), for: .normal)
    button.alpha = 0.5
    return button
  }()
  
  let passcode4: UIButton = {
    let button = UIButton(type: .custom)
    button.setImage(UIImage(named: "PasscodeIcon"), for: .normal)
    button.alpha = 0.5
    return button
  }()
  
  let oneBtn: UIButton = {
    let button = UIButton(type: .system)
    button.addTarget(self, action: #selector(checkingPasscode(_:)), for: .touchUpInside)
    button.setTitle("1", for: .normal)
    button.titleLabel?.font = UIFont(name: "NanumPen", size: 45)
    button.setTitleColor(.appColor(.appFontColor), for: .normal)
    
    return button
  }()
  let twoBtn: UIButton = {
    let button = UIButton(type: .system)
    button.addTarget(self, action: #selector(checkingPasscode(_:)), for: .touchUpInside)
    button.setTitle("2", for: .normal)
    button.titleLabel?.font = UIFont(name: "NanumPen", size: 45)
    button.setTitleColor(.appColor(.appFontColor), for: .normal)
    
    return button
  }()
  let threeBtn: UIButton = {
    let button = UIButton(type: .system)
    button.addTarget(self, action: #selector(checkingPasscode(_:)), for: .touchUpInside)
    button.setTitle("3", for: .normal)
    
    button.titleLabel?.font = UIFont(name: "NanumPen", size: 45)
    button.setTitleColor(.appColor(.appFontColor), for: .normal)
    return button
  }()
  let fourBtn: UIButton = {
    let button = UIButton(type: .system)
    button.addTarget(self, action: #selector(checkingPasscode(_:)), for: .touchUpInside)
    button.setTitle("4", for: .normal)
    button.titleLabel?.font = UIFont(name: "NanumPen", size: 45)
    button.setTitleColor(.appColor(.appFontColor), for: .normal)
    
    return button
  }()
  let fiveBtn: UIButton = {
    let button = UIButton(type: .system)
    button.addTarget(self, action: #selector(checkingPasscode(_:)), for: .touchUpInside)
    button.setTitle("5", for: .normal)
    button.titleLabel?.font = UIFont(name: "NanumPen", size: 45)
    button.setTitleColor(.appColor(.appFontColor), for: .normal)
    return button
  }()
  let sixBtn: UIButton = {
    let button = UIButton(type: .system)
    button.addTarget(self, action: #selector(checkingPasscode(_:)), for: .touchUpInside)
    button.setTitle("6", for: .normal)
    button.titleLabel?.font = UIFont(name: "NanumPen", size: 45)
    button.setTitleColor(.appColor(.appFontColor), for: .normal)
    return button
  }()
  let sevenBtn: UIButton = {
    let button = UIButton(type: .system)
    button.addTarget(self, action: #selector(checkingPasscode(_:)), for: .touchUpInside)
    button.setTitle("7", for: .normal)
    button.titleLabel?.font = UIFont(name: "NanumPen", size: 45)
    button.setTitleColor(.appColor(.appFontColor), for: .normal)
    
    return button
  }()
  let eightBtn: UIButton = {
    let button = UIButton(type: .system)
    button.addTarget(self, action: #selector(checkingPasscode(_:)), for: .touchUpInside)
    button.setTitle("8", for: .normal)
    button.titleLabel?.font = UIFont(name: "NanumPen", size: 45)
    button.setTitleColor(.appColor(.appFontColor), for: .normal)
    
    return button
  }()
  let nineBtn: UIButton = {
    let button = UIButton(type: .system)
    button.addTarget(self, action: #selector(checkingPasscode(_:)), for: .touchUpInside)
    button.setTitle("9", for: .normal)
    button.titleLabel?.font = UIFont(name: "NanumPen", size: 45)
    button.setTitleColor(.appColor(.appFontColor), for: .normal)
    
    return button
  }()
  let zeroBtn: UIButton = {
    let button = UIButton(type: .system)
    button.addTarget(self, action: #selector(checkingPasscode(_:)), for: .touchUpInside)
    button.setTitle("0", for: .normal)
    button.titleLabel?.font = UIFont(name: "NanumPen", size: 45)
    button.setTitleColor(.appColor(.appFontColor), for: .normal)
    
    return button
  }()
  let deleteBtn: UIButton = {
    let button = UIButton(type: .system)
//    button.addTarget(self, action: #selector(checkingPasscode(_:)), for: .touchUpInside)
    button.setTitle("⇠", for: .normal)
    button.titleLabel?.font = UIFont(name: "NanumPen", size: 45)
    button.setTitleColor(.appColor(.appFontColor), for: .normal)
    return button
  }()
  
  let blankBtn: UIButton = {
    let button = UIButton(type: .system)
    return button
  }()
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    setupStackView()
    addSubviews()
    setupSNP()
  }
  
  @objc func checkingPasscode(_ sender: UIButton) {
    
    guard let input = sender.currentTitle else { return }
    imageStackView.arrangedSubviews[0].alpha = 1
    delegate?.didTapButton(input: input)
    
  }
  
  @objc func deleteBtnDidTap(_ sender: UIButton) {
    
  }
  
  private func setupStackView() {
    // imageStackView
    
   
    // firstStackView
    firstStackView = UIStackView(arrangedSubviews: [oneBtn, twoBtn, threeBtn, blankBtn])
    firstStackView.axis = .horizontal
    firstStackView.distribution = .fillEqually
    firstStackView.spacing = 15
    
    //secondStackView
    secondStackView = UIStackView(arrangedSubviews: [fourBtn, fiveBtn, sixBtn, zeroBtn])
    secondStackView.axis = .horizontal
    secondStackView.distribution = .fillEqually
    secondStackView.spacing = 15
    
    //thirdStackView
    thirdStackView = UIStackView(arrangedSubviews: [sevenBtn, eightBtn, nineBtn, deleteBtn])
    thirdStackView.axis = .horizontal
    thirdStackView.distribution = .fillEqually
    thirdStackView.spacing = 15
    
  }
  
  private func addSubviews() {
    [imageView, imageStackView, firstStackView, secondStackView, thirdStackView]
      .forEach { self.addSubview($0) }
  }
  
  private func setupSNP() {
    imageView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()
    }
    
//    logoImageView.snp.makeConstraints {
//      $0.bottom.equalTo(imageStackView.snp.top).offset(5)
//      $0.centerX.equalToSuperview()
//      $0.height.width.equalTo(100)
//    }

    imageStackView.snp.makeConstraints {
      $0.centerY.equalToSuperview()
//      $0.width.height.equalTo(40)
//      $0.top.equalTo(UIScreen.main.bounds.height * 0.13)
      $0.centerX.equalToSuperview()
    }
    firstStackView.snp.makeConstraints {
      $0.bottom.equalTo(-UIScreen.main.bounds.height / 4)
      $0.leading.trailing.equalToSuperview().inset(40)
//      $0.height.equalTo(30)
    }
    secondStackView.snp.makeConstraints {
//      $0.bottom.equalTo(-UIScreen.main.bounds.height / 10)
      $0.top.equalTo(firstStackView.snp.bottom)
      $0.leading.trailing.equalToSuperview().inset(40)
//      $0.height.equalTo(30)
    }
    thirdStackView.snp.makeConstraints {
//      $0.bottom.equalTo(-UIScreen.main.bounds.height / 24)
      $0.top.equalTo(secondStackView.snp.bottom)
      $0.leading.trailing.equalToSuperview().inset(40)
//      $0.height.equalTo(30)
    }
    
  }
  
  
  
}
