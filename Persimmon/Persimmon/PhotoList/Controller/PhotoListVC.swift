//
//  PhotoListVC.swift
//  Persimmon
//
//  Created by Jeon-heaji on 2019/10/14.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit

class PhotoListVC: UIViewController {
  
  let photoListView = PhotoListView()
  let photoEmptyView = PhotoListViewEmpty()
  let alertVC = CustomAlertVC()
  
  override func loadView() {
    self.view = photoListView
  }

    override func viewDidLoad() {
        super.viewDidLoad()
      
      view.backgroundColor = .white
      photoListView.backBtn.addTarget(self, action: #selector(backButtonDidTap(_:)), for: .touchUpInside)
      photoListView.addBtn.addTarget(self, action: #selector(addButtonDidTap(_:)), for: .touchUpInside)
     
    }
  
  @objc func backButtonDidTap(_ sender: UIButton) {
      print("눌림")
    navigationController?.popViewController(animated: true)
      
    }
  
  // MARK: - add버튼 눌렀을때 alert띄우기
  @objc func addButtonDidTap(_ sender: Any) {
//    photoListView.createAlert()

    //1. 알림창을 경고 형식으로 정의 한다.

    let alert = UIAlertController(title: nil, message: "가져오기",preferredStyle: .actionSheet)

    //2. 버튼을 정의 한다.

    let libraryAction = UIAlertAction(title: "앨범", style: .default) {
         [unowned self] (alert) -> Void in
//         let imagePicker = UIImagePickerController()
//         imagePicker.delegate = self
//         imagePicker.sourceType = .photoLibrary
//         self.present(imagePicker, animated: true)
       let selecAlbumVC = SelectAlbumVC()
      self.present(selecAlbumVC, animated: true)
    }

    let cameraAction = UIAlertAction(title: "카메라", style: .default) {
      [unowned self] (alert) -> Void in
      let imagePicker = UIImagePickerController()
      imagePicker.delegate = self
      imagePicker.sourceType = .camera
      self.present(imagePicker, animated: true)
    }
    //3. 정의된 버튼을 알림창 객체에 추가한다.

    alert.addAction(libraryAction)
    alert.addAction(cameraAction)
    let contentVC = CustomAlertVC()
    alert.view.tintColor = UIColor.appColor(.appGreenColor)
    // 뷰 컨트롤러 알림창의 콘텐츠 뷰 컨트롤러 속성에 등록한다.

    alert.setValue(contentVC, forKeyPath: "contentViewController")

    //4. 알림창을 화면에 표시한다.

    self.present(alert, animated: false)

  }
  
}

extension PhotoListVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    let image = info[.originalImage] as? UIImage
//    self.faceImageView.image = image
    picker.dismiss(animated: true)
  }
}

