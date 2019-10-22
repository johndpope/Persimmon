//
//  PhotoListVC.swift
//  Persimmon
//
//  Created by Jeon-heaji on 2019/10/14.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import Photos
import TLPhotoPicker
import RealmSwift

class PhotoListVC: UIViewController {
  
  var uuid: String = ""
  
  var notificationToken: NotificationToken? = nil
  
  var object: Album? {
    return RealmSingleton.shared.takeSelectAlbum(albumUUID: uuid)
  }
  
  let photoListView = PhotoListView()
  let alertVC = CustomAlertVC()
  
  override func loadView() {
    self.view = photoListView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    notificationToken = RealmSingleton.shared.realm.observe({ [weak self] (noti, realm) in
      guard let `self` = self else { return }
      DispatchQueue.main.async {
        self.photoListView.photoView.collectionView.reloadData()
        self.photoListView.topView.listNumberLabel.text = "완료"
      }
    })
    
    view.backgroundColor = .white
    photoListView.topView.backBtn.addTarget(self, action: #selector(backButtonDidTap(_:)), for: .touchUpInside)
    photoListView.addBtn.addTarget(self, action: #selector(addButtonDidTap(_:)), for: .touchUpInside)
    
    photoListView.photoView.collectionView.register(UINib(nibName: "PhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PhotoCollectionViewCell")
    photoListView.photoView.collectionView.delegate = self
    photoListView.photoView.collectionView.dataSource = self
    
  }
  
  @objc func backButtonDidTap(_ sender: UIButton) {
    print("눌림")
    //    navigationController?.viewControllers = (navigationController?.viewControllers.dropLast())!
    navigationController?.popViewController(animated: true)
    
  }
  
  // MARK: - add버튼 눌렀을때 alert띄우기
  @objc func addButtonDidTap(_ sender: Any) {
    //    photoListView.createAlert()
    
    //1. 알림창을 경고 형식으로 정의 한다.
    
    let alert = UIAlertController(title: "", message: "가져오기",preferredStyle: .actionSheet)
    
    //2. 버튼을 정의 한다.
    
    let libraryAction = UIAlertAction(title: "앨범", style: .default) {
      [unowned self] (alert) -> Void in
      //      guard let `self` = self else { return }
      let vc = TLPhotosPickerViewController()
      vc.configure.cancelTitle = "취소"
      vc.configure.doneTitle = "완료"
      vc.configure.tapHereToChange = "탭해서 바꾸기"
      vc.configure.emptyMessage = "앨범 없음"
      vc.configure.recordingVideoQuality = .typeHigh
      vc.configure.selectedColor = .appColor(.appPersimmonColor)
      vc.delegate = self
      
      //        vc.configure.customLocalizedTitle = ["카메라 롤": "카메라 롤"]
      //        vc.configure.cameraBgColor = .appColor(.appPersimmonColor)
      //       let selecAlbumVC = SelectAlbumVC()
      self.present(vc, animated: true)
    }
    
    let cameraAction = UIAlertAction(title: "카메라", style: .default) {
      [unowned self] (alert) -> Void in
//      guard let `self` = self else { return }
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
    DispatchQueue(label: "tass", qos: .userInteractive, attributes: .concurrent).async {
      RealmSingleton.shared.writeData(
        albumUUID: self.uuid,
        localNames: TassPhoto().saveMediaFiles(
          assets: withPHAssets,
          progress: { [weak self] (count, total) in
//          print("progress: \(count) / \(total)")
            guard let `self` = self else { return }
            DispatchQueue.main.async {
              self.photoListView.topView.listNumberLabel.text = "\(count) / \(total)"
            }
            
        })) { (failCount) in
          print("failCount: ", failCount)
      }
    }
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
    cell.photoUUID = photo.uuid
    cell.cellType = photo.type
    cell.videoName = photo.videoName
    cell.imageName = photo.imageName
    cell.thumbnail = photo.thumbnail
    
    return cell
  }
}

extension PhotoListVC: UICollectionViewDelegate {
  
}



public struct PhotosPickerConfigure {
  public var emptyImage: UIImage? = nil
  public var usedCameraButton = false
  public var usedPrefetch = false
  public var allowedLivePhotos = true
  public var allowedVideo = true
  public var allowedAlbumCloudShared = false
  public var allowedVideoRecording = false
  public var recordingVideoQuality: UIImagePickerController.QualityType = .typeHigh
  public var maxVideoDuration:TimeInterval? = nil
  public var autoPlay = false
  public var muteAudio = true
  public var mediaType: PHAssetMediaType? = nil
  public var numberOfColumn = UserDefaults.standard.bool(forKey: "scale") ? 3 : 4
  public var singleSelectedMode = false
  public var maxSelectedAssets: Int? = nil
  public var fetchOption: PHFetchOptions? = nil
  public var selectedColor = UIColor.appColor(.appPersimmonColor)
  public var cameraBgColor = UIColor(red: 221/255, green: 223/255, blue: 226/255, alpha: 1)
  public var cameraIcon = UIImage(named: "camera")
  public var videoIcon = UIImage(named: "video")
  public var placeholderIcon = UIImage(named: "insertPhotoMaterial")
  public var fetchCollectionTypes: [(PHAssetCollectionType,PHAssetCollectionSubtype)]? = nil
  public var supportedInterfaceOrientations: UIInterfaceOrientationMask = .portrait
  public init() {
    
  }
  
}


