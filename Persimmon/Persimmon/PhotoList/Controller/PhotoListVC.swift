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
  
  lazy var object = RealmSingleton.shared.takeSelectAlbum(uuid: uuid, selectRealm: nil)
  
  let photoListView = PhotoListView()
  let photoEmptyView = PhotoListViewEmpty()
  let alertVC = CustomAlertVC()
  
  override func loadView() {
    self.view = photoListView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    notificationToken = RealmSingleton.shared.realm.observe({ (noti, realm) in
      print("here reload")
      DispatchQueue.main.async {
        self.photoListView.photoView.collectionView.reloadData()
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
    let uuid = UUID().uuidString
    TassPhoto().saveMediaFile(asset: withPHAssets.first, uuid: uuid) { (localURL, mimeType) in
      print("result: ", localURL, mimeType)
    }
  }
  
  func dismissPhotoPicker(withTLPHAssets: [TLPHAsset]) {
    
//    let manager = PHImageManager()
//    let option = PHLivePhotoRequestOptions()
//    option.deliveryMode = .highQualityFormat
//    option.isNetworkAccessAllowed = true
//    option.version = .original
//    option.progressHandler = { (per, err, state, info) in
//      print("here percent: \(per), useUnsafe: \(state)")
//    }
//
//    withTLPHAssets.forEach { (asset) in
//        RealmSingleton.shared.writeWithPhoto(albumUUID: self.uuid, asset: asset)
//    }
    
    
    
    
    
    
    
    
    
    
    //    _ = withTLPHAssets.first?.exportVideoFile(options: nil, outputURL: nil, outputFileType: .mov, progressBlock: { (percent) in
    //      print("here percent: ", percent)
    //    }, completionBlock: { (url, str) in
    //      print("here result - url: ", url, "\nstr: ", str)
    //    })
    
    //    let manager = PHImageManager()
    //    let manager = assetresource
    
    //    let asset = withTLPHAssets.first
    //    let manager = PHAssetResourceManager()
    //
    //    func videoFilename(phAsset: PHAsset) -> URL? {
    //      guard let resource = (PHAssetResource.assetResources(for: phAsset).filter{ $0.type == .video }).first else {
    //        return nil
    //      }
    //      var writeURL: URL?
    //      let fileName = resource.originalFilename
    //      if #available(iOS 10.0, *) {
    //        writeURL = FileManager.default.temporaryDirectory.appendingPathComponent("\(fileName)")
    //
    //        let documentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("\(fileName)")
    //        print("here path: ", documentsDir)
    //
    //      } else {
    //        writeURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true).appendingPathComponent("\(fileName)")
    //      }
    //
    //      let testAsset = PHCachingImageManager()
    //      let option = PHFetchOptions()
    //      let collection = PHAssetCollection()
    //      collection
    //      let test1 = PHAssetCreationRequest.forAsset()
    //      let test2 = NSMutableData() as? PHLivePhoto
    //      PHLivePhoto.request(withResourceFileURLs: <#T##[URL]#>, placeholderImage: <#T##UIImage?#>, targetSize: <#T##CGSize#>, contentMode: .aspectFit, resultHandler: <#T##(PHLivePhoto?, [AnyHashable : Any]) -> Void#>)
    //      return writeURL
    //    }
    //
    //    print("here: url: ", videoFilename(phAsset: (asset?.phAsset)!))
    //
    //    guard let phAsset = asset?.phAsset, asset?.type == .photo || asset?.type == .livePhoto else { return }
    //    var resource: PHAssetResource? = nil
    //    if phAsset.mediaSubtypes.contains(.photoLive) == true {
    //      resource = PHAssetResource.assetResources(for: phAsset).filter { $0.type == .pairedVideo }.first
    //
    //    }else {
    //      resource = PHAssetResource.assetResources(for: phAsset).filter { $0.type == .photo }.first
    //    }
    //
    ////    let test = PHAssetResource.assetResources(for: phAsset).first
    //
    //    let options = PHAssetResourceRequestOptions()
    //    options.isNetworkAccessAllowed = true
    //    options.progressHandler = { (per) in
    //      print(per)
    //    }
    //
    //    print("here resource: ", resource)
    //
    //    manager.requestData(for: resource!, options: options, dataReceivedHandler: { (data) in
    //      print("here data: ", data)
    //    }) { (err) in
    //      print("here err: ", err)
    //    }
    //
    //
    //
    //
    //    if let fileSize = resource?.value(forKey: "fileSize") as? Int {
    //      print("here fileSize1: ", fileSize)
    //    }else {
    //      PHImageManager.default().requestImageData(for: phAsset, options: nil) { (data, uti, orientation, info) in
    //        var fileSize = -1
    //        if let data = data {
    //          let bcf = ByteCountFormatter()
    //          bcf.countStyle = .file
    //          fileSize = data.count
    //        }
    //        DispatchQueue.main.async {
    //          print("here fileSize2: ", fileSize)
    //        }
    //      }
    //    }
    //
    //
    
    
    
  }
}


extension PhotoListVC: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return object?.photos.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
    
    cell.configure = PhotosPickerConfigure()
    cell.imageView?.image = UIImage(data: object?.photos[indexPath.row].photoData ?? Data())
    cell.liveBadgeImageView?.image = nil
    cell.isCameraCell = false
    
    
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
//  public var nibSet: (nibName: String, bundle:Bundle)? = nil
//  public var cameraCellNibSet: (nibName: String, bundle:Bundle)? = nil
  public var fetchCollectionTypes: [(PHAssetCollectionType,PHAssetCollectionSubtype)]? = nil
  public var supportedInterfaceOrientations: UIInterfaceOrientationMask = .portrait
  public init() {
    
  }
  
}


