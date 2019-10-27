//
//  PhotoListVC.swift
//  Persimmon
//
//  Created by Jeon-heaji on 2019/10/14.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import Photos
import PhotosUI
import TLPhotoPicker
import RealmSwift



class PhotoListVC: UIViewController {
  var backgroundTask: UIBackgroundTaskIdentifier = .invalid
  
  var uuid: String = ""
  let photoListView = PhotoListView()
  let alertVC = CustomAlertVC()
  var notificationToken: NotificationToken? = nil
  var selectedPhotos = [SelectedPhoto]()
  let popUpView = PopUpView(frame: .zero, modify: "이동")
  
  var object: Album? {
    return RealmSingleton.shared.takeSelectAlbum(albumUUID: uuid)
    
  }
  
  var collectionView: UICollectionView {
    return photoListView.photoView.collectionView
  }
  
  var selectBtnState: Bool {
    return photoListView.topView.selectBtn.isSelected
  }
  
  override func loadView() {
    self.view = photoListView
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    notificationToken = RealmSingleton.shared.realm.observe({ [weak self] (noti, realm) in
      guard let `self` = self else { return }
      DispatchQueue.main.async {
        self.photoListView.photoView.collectionView.reloadData()
        self.photoListView.topView.listNumberLabel.text = self.takeSubTitle()
        self.photoListView.topView.profileImageView.image = self.takeLastImage()
        
      }
    })
    
  }
  
  private func setupView() {
    view.backgroundColor = .white
    photoListView.topView.addSubview(popUpView)
    setupSNP()
    photoListView.topView.backBtn.addTarget(self,
                                            action: #selector(didTapBackBtn(_:)),
                                            for: .touchUpInside)
    photoListView.topView.selectBtn.addTarget(self,
                                              action: #selector(didTapSelectBtn(_:)),
                                              for: .touchUpInside)
    photoListView.addBtn.addTarget(self,
                                   action: #selector(addButtonDidTap(_:)),
                                   for: .touchUpInside)
    popUpView.cancelBtn.addTarget(self,
                                  action: #selector(didTapCancelBtn(_:)),
                                  for: .touchUpInside)
    popUpView.deleteBtn.addTarget(self,
                                  action: #selector(didTapDeleteBtn(_:)),
                                  for: .touchUpInside)
    popUpView.modifyBtn.addTarget(self,
                                  action: #selector(didTapModifyBtn(_:)),
                                  for: .touchUpInside)
    collectionView.delegate = self
    collectionView.dataSource = self
    photoListView.topView.albumTitle.text = object?.title ?? "애러당!"
    photoListView.topView.listNumberLabel.text = takeSubTitle()
    photoListView.topView.profileImageView.image = takeLastImage()
    
  }
  
  private func setupSNP() {
    popUpView.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.height.equalTo(50)
      $0.trailing.equalToSuperview().offset(200)
      $0.width.equalToSuperview().multipliedBy(0.3)
    }
  }
  
  private func takeLastImage() -> UIImage? {
    guard let lastPhoto = object?.photos.last else {
      return UIImage(named: "icon") }
    let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let imageData = try? Data(contentsOf: url.appendingPathComponent("\(String(describing: lastPhoto.photoUUID))/\(String(describing: lastPhoto.thumbnail))"))
    return UIImage(data: imageData ?? Data())
    
  }
  
  private func takeSubTitle() -> String {
    let totalCount = object?.photos.count ?? 0
    let videoCount = object?.photos.filter("type = 'video'").count ?? 0
    let photoCount = totalCount - videoCount
    return "\(photoCount) Photos, \(videoCount) videos"
    
  }
  
  @objc func didTapBackBtn(_ sender: UIButton) {
    navigationController?.popViewController(animated: true)
    
  }
  
  @objc func didTapSelectBtn(_ sender: UIButton) {
    popUpView.snp.remakeConstraints {
      $0.top.height.equalTo(photoListView.topView.selectBtn)
      $0.trailing.equalToSuperview().offset(-5)
      $0.width.equalToSuperview().multipliedBy(0.3)
    }
    
    photoListView.topView.selectBtn.isHidden.toggle()
    photoListView.topView.selectBtn.isEnabled.toggle()
    photoListView.topView.selectBtn.isSelected.toggle()
    popUpView.isHidden = false
  }
  
  @objc func didTapCancelBtn(_ sender: UIButton) {
    print("printDidCancel")
    let tempIndex: [IndexPath] = selectedPhotos.compactMap { (photo) -> IndexPath? in
      photo.index
    }
    hiddenPopUpView()
    collectionView.reloadItems(at: tempIndex)
  }
  
  @objc func didTapModifyBtn(_ sender: UIButton) {
    hiddenPopUpView()

  }
  
  @objc func didTapDeleteBtn(_ sender: UIButton) {
    print("didTapDelete")
    let RowArr: [Int] = selectedPhotos.compactMap { (indexPath) -> Int? in
      indexPath.index.row
    }
    
    RealmSingleton.shared.moveToOther(from: uuid, Arr: RowArr)
    
    hiddenPopUpView()
  }
  
  private func hiddenPopUpView() {
    self.popUpView.snp.remakeConstraints {
      $0.top.equalToSuperview()
      $0.height.equalTo(50)
      $0.trailing.equalToSuperview().offset(200)
      $0.width.equalToSuperview().multipliedBy(0.3)
    }
    photoListView.topView.selectBtn.isHidden.toggle()
    photoListView.topView.selectBtn.isEnabled.toggle()
    photoListView.topView.selectBtn.isSelected.toggle()
    popUpView.isHidden = true
    selectedPhotos = []
  }
  
  // MARK: - add버튼 눌렀을때 alert띄우기
  @objc func addButtonDidTap(_ sender: Any) {
    //1. 알림창을 경고 형식으로 정의 한다.
    
    let alert = UIAlertController(title: "", message: "가져오기",preferredStyle: .actionSheet)
    
    //2. 버튼을 정의 한다.
    
    let libraryAction = UIAlertAction(title: "앨범", style: .default) {
      [unowned self] (alert) -> Void in
      let vc = TLPhotosPickerViewController()
      vc.configure.cancelTitle = "취소"
      vc.configure.doneTitle = "완료"
      vc.configure.tapHereToChange = "탭해서 바꾸기"
      vc.configure.emptyMessage = "앨범 없음"
      vc.configure.recordingVideoQuality = .typeHigh
      vc.configure.selectedColor = .appColor(.appPersimmonColor)
      vc.delegate = self
      self.present(vc, animated: true)
    }
    
    let cameraAction = UIAlertAction(title: "카메라", style: .default) {
      [unowned self] (alert) -> Void in
      let imagePicker = UIImagePickerController()
      imagePicker.delegate = self
      imagePicker.sourceType = .camera
      self.present(imagePicker, animated: true)
    }
    
    let cancelAction = UIAlertAction(title: "취소", style: .destructive)
    //3. 정의된 버튼을 알림창 객체에 추가한다.
    
    alert.addAction(libraryAction)
    alert.addAction(cameraAction)
    alert.addAction(cancelAction)
    let contentVC = CustomAlertVC()
    alert.view.tintColor = UIColor.appColor(.appGreenColor)
    // 뷰 컨트롤러 알림창의 콘텐츠 뷰 컨트롤러 속성에 등록한다.
    
    alert.setValue(contentVC, forKeyPath: "contentViewController")
    
    //4. 알림창을 화면에 표시한다.
    
    self.present(alert, animated: false)
    
  }
  
  deinit {
    print("deinit at PhotoListVC")
    notificationToken?.invalidate()
    print("Background task during.")
    if self.backgroundTask != .invalid {
      self.endBackgroundTask() }
    
  }
  
  
}

extension PhotoListVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    //    let image = info[.originalImage] as? UIImage
    //    self.faceImageView.image = image
    picker.dismiss(animated: true)
    
  }
  
  
}

extension PhotoListVC: TLPhotosPickerViewControllerDelegate {
  func dismissPhotoPicker(withPHAssets: [PHAsset]) {
    
    DispatchQueue(label: "tass",
                  qos: .default,
                  attributes: .concurrent)
      .async { [weak self] in
        guard let `self` = self else { return }
        self.registerBackgroundTask()
        let localNames = TassPhoto().saveMediaFiles(
          assets: withPHAssets,
          progress: {
            [weak self] (count, total) in
            guard let `self` = self else {
              return }
            DispatchQueue.main
              .async { [weak self] in
                guard let `self` = self else { return }
                self.photoListView.topView.listNumberLabel.text = "\(count) / \(total)"
            }
        })
        
        RealmSingleton.shared.writeData(
          albumUUID: self.uuid,
          localNames: localNames) {
            (failCount) in
            print("failCount: ", failCount)
            PHPhotoLibrary.shared().performChanges({
              PHAssetChangeRequest.deleteAssets(withPHAssets as NSArray)
            })
        }
    }
    
  }
  
  func registerBackgroundTask() {
    backgroundTask = UIApplication.shared.beginBackgroundTask(withName: "tassBackGround", expirationHandler: { [weak self] in
      self?.endBackgroundTask()
    })
    assert(backgroundTask != .invalid)
    DispatchQueue.main.async {
      print("Background time remaining = " +
        "\(UIApplication.shared.backgroundTimeRemaining) seconds")
    }
    
  }
  
  func endBackgroundTask() {
    print("Background task ended.")
    UIApplication.shared.endBackgroundTask(backgroundTask)
    backgroundTask = .invalid
  }
  
  func dismissComplete() {
    print("dismiss TLPhotoVC")
    
  }
  
  
}


extension PhotoListVC: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return object?.photos.count ?? 0
    
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
    cell.liveBadgeImageView?.image = nil
    cell.isCameraCell = false
    
    guard let photo = object?.photos[indexPath.row] else { return cell }
    cell.configure = PhotosPickerConfigure()
    cell.cellConfigure(photo: photo)
    
    for photo in selectedPhotos {
      if photo.index == indexPath {
        cell.selectedAsset = true
        cell.orderLabel?.text = "\(photo.order)"
        break
      }
    }
    
    cell.alpha = 0
    UIView.transition(with: cell, duration: 0.1, options: .curveEaseIn, animations: {
      cell.alpha = 1
    }, completion: nil)
    return cell
    
  }
  
  
}



extension PhotoListVC: UICollectionViewDelegate {
  func orderUpdateCells() {
    let visibleIndexPaths = self.collectionView.indexPathsForVisibleItems.sorted(by: { $0.row < $1.row })
    for indexPath in visibleIndexPaths {
      guard let cell = self.collectionView.cellForItem(at: indexPath) as? PhotoCollectionViewCell else { continue }
      for photo in selectedPhotos {
        if photo.index == indexPath {
          cell.selectedAsset = true
          cell.orderLabel?.text = "\(photo.order)"
          break
        } else {
          cell.selectedAsset = false
          cell.orderLabel?.text = nil
        }
      }
    }
    
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard selectBtnState, let cell = collectionView.cellForItem(at: indexPath) as? PhotoCollectionViewCell else { return }
    
    cell.popScaleAnim()
    if let index = self.selectedPhotos.firstIndex(where: { $0.index == indexPath }) {
      //deselect
      self.selectedPhotos.remove(at: index)
      #if swift(>=4.1)
      self.selectedPhotos = self.selectedPhotos.enumerated().compactMap({ (offset, photo) -> SelectedPhoto? in
        let photo = photo
        photo.order = offset + 1
        return photo
      })
      #else
      self.selectedPhotos = self.selectedPhotos.enumerated().flatMap({ (offset, photo) -> TLPHAsset? in
        var photo = photo
        photo.order = offset + 1
        return photo
      })
      #endif
      cell.selectedAsset = false
      self.orderUpdateCells()
    }else {
      //select
      let photo = SelectedPhoto(index: indexPath, order: self.selectedPhotos.count + 1)
      self.selectedPhotos.append(photo)
      cell.selectedAsset = true
      cell.orderLabel?.text = "\(photo.order)"
    }
  }
  
  
}






