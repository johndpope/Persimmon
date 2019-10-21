//
//  AlertVC.swift
//  Persimmon
//
//  Created by Jeon-heaji on 2019/10/14.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit

class CustomAlertVC: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //1.이미지와 이미지 뷰 객체 생성
    
    let cameraIcon = UIImage(named: "photoCamera") //실제 이미지를 저장하는 객체
    
    let cameraIconImgView = UIImageView(image:cameraIcon) // 이미지 객체를 이용해서 화면에 표시하는 뷰의 일종
    cameraIconImgView.tintColor = .appColor(.appFontColor)
    
    let library = UIImage(named: "photoAttach")
    let libraryIconImgView = UIImageView(image:library) // 이미지 객체를 이용해서 화면에 표시하는 뷰의 일종
    libraryIconImgView.tintColor = .appColor(.appFontColor)
    
    //2. 이미지 뷰의 영역과 위치를 지정
    
    cameraIconImgView.frame = CGRect(
      x: view.frame.width * 0.7, y:0, width:(cameraIcon?.size.width)!,height:(cameraIcon?.size.height)!)
    
    libraryIconImgView.frame = CGRect(
      x: view.frame.width * 0.2, y: 0, width:(library?.size.width)!,height:(library?.size.height)!)
    
    
    //3. 루트뷰에 이미지 뷰를 추가
    
    self.view.addSubview(cameraIconImgView)
    self.view.addSubview(libraryIconImgView)
    
    
    //preferredContentSize 속성을 통해 외부 객체가 ImageViewController를 나타낼 때 참고할 사이즈 지정
    
    //4.  외부에서 참조할 뷰 컨트롤러 사이즈를 이미지 크기와 동일하게 설정 + 10은 알림창에 이미지가 표시될때 아래 여백 주기
    
    self.preferredContentSize = CGSize(width:(cameraIcon?.size.width)!,height:(cameraIcon?.size.height)!+10)
    self.preferredContentSize = CGSize(width:(library?.size.width)!,height:(library?.size.height)!+10)
    
    
  }
  
  
}
