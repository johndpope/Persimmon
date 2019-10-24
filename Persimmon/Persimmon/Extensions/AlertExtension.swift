//
//  AlertExtension.swift
//  Persimmon
//
//  Created by hyeoktae kwon on 2019/10/25.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit

extension UIAlertController {
  
  enum ErrorType: Error {
    case cancel
  }
  
  func makeTextFieldAlert(title: String?, mesage: String, actionTitle: String, vc: UIViewController, completion: @escaping (Result<String?, ErrorType>) -> ()) {
    let alert = UIAlertController(title: title, message: mesage ,preferredStyle: .alert)

    //2. add textfield
    alert.addTextField()
    alert.textFields?.first?.placeholder = "타이틀을 입력하세요"
    //3. 버튼을 정의 한다.

    let cameraAction = UIAlertAction(title: actionTitle, style: .default) { (_) -> Void in
      let text = alert.textFields?.first?.text
      completion(.success(text))
    }

    let cancelAction = UIAlertAction(title: "취소", style: .cancel) { (_) -> Void in
      completion(.failure(.cancel))
    }
    //4. 정의된 버튼을 알림창 객체에 추가한다.


    alert.addAction(cameraAction)
    alert.addAction(cancelAction)
//    let contentVC = CustomAlertVC()
    alert.view.tintColor = UIColor.appColor(.appGreenColor)
    // 뷰 컨트롤러 알림창의 콘텐츠 뷰 컨트롤러 속성에 등록한다.

//    alert.setValue(contentVC, forKeyPath: "contentViewController")

    //4. 알림창을 화면에 표시한다.

    vc.present(alert, animated: true)

  }
  
  func makeAlert(title: String?, mesage: String, actionTitle: String, vc: UIViewController, completion: @escaping (Bool) -> ()) {
      let alert = UIAlertController(title: title, message: mesage ,preferredStyle: .alert)

      //2. add textfield
//      alert.addTextField()
//      alert.textFields?.first?.placeholder = "타이틀을 입력하세요"
      //3. 버튼을 정의 한다.

      let cameraAction = UIAlertAction(title: actionTitle, style: .default) { (_) -> Void in
        completion(true)
      }

      let cancelAction = UIAlertAction(title: "취소", style: .cancel) { (_) -> Void in
        completion(false)
      }
      //4. 정의된 버튼을 알림창 객체에 추가한다.


      alert.addAction(cameraAction)
      alert.addAction(cancelAction)
  //    let contentVC = CustomAlertVC()
      alert.view.tintColor = UIColor.appColor(.appGreenColor)
      // 뷰 컨트롤러 알림창의 콘텐츠 뷰 컨트롤러 속성에 등록한다.

  //    alert.setValue(contentVC, forKeyPath: "contentViewController")

      //4. 알림창을 화면에 표시한다.

      vc.present(alert, animated: true)

    }
}


