//
//  CustomPhotoPicker.swift
//  Persimmon
//
//  Created by hyeoktae kwon on 2019/10/13.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import Photos
import TLPhotoPicker


public struct PickerConfigure {
  public var customLocalizedTitle: [String: String] = ["Camera Roll": "Camera Roll"]
  public var tapHereToChange = "탭해서 바꾸기"
  public var cancelTitle = "취소"
  public var doneTitle = "완료"
  public var emptyMessage = "앨범 없음"
  public var emptyImage: UIImage? = nil
  public var usedCameraButton = true
  public var usedPrefetch = false
  public var allowedLivePhotos = true
  public var allowedVideo = true
  public var allowedAlbumCloudShared = false
  public var allowedVideoRecording = true
  public var recordingVideoQuality: UIImagePickerController.QualityType = .typeHigh
  public var maxVideoDuration:TimeInterval? = nil
  public var autoPlay = true
  public var muteAudio = true
  public var mediaType: PHAssetMediaType? = nil
  public var numberOfColumn = 3
  public var singleSelectedMode = false
  public var maxSelectedAssets: Int? = nil
  public var fetchOption: PHFetchOptions? = nil
  public var fetchCollectionOption: [FetchCollectionType: PHFetchOptions] = [:]
  public var selectedColor = UIColor.appColor(.appPersimmonColor)
  public var cameraBgColor = UIColor.appColor(.appPersimmonColor)
  public var cameraIcon = TLBundle.podBundleImage(named: "camera")
  public var videoIcon = TLBundle.podBundleImage(named: "video")
  public var placeholderIcon = TLBundle.podBundleImage(named: "insertPhotoMaterial")
  public var nibSet: (nibName: String, bundle:Bundle)? = nil
  public var cameraCellNibSet: (nibName: String, bundle:Bundle)? = nil
  public var fetchCollectionTypes: [(PHAssetCollectionType,PHAssetCollectionSubtype)]? = nil
  public var groupByFetch: PHFetchedResultGroupedBy? = nil
  public var supportedInterfaceOrientations: UIInterfaceOrientationMask = .portrait
  public var popup: [PopupConfigure] = []
  public init() {
    
  }
}

//Related issue: https://github.com/tilltue/TLPhotoPicker/issues/201
//e.g.
//let option = PHFetchOptions()
//configure.fetchCollectionOption[.assetCollections(.smartAlbum)] = option
//configure.fetchCollectionOption[.assetCollections(.album)] = option
//configure.fetchCollectionOption[.topLevelUserCollections] = option

public enum FetchCollectionType {
  case assetCollections(PHAssetCollectionType)
  case topLevelUserCollections
}

extension FetchCollectionType: Hashable {
  private var identifier: String {
    switch self {
    case let .assetCollections(collectionType):
      return "assetCollections\(collectionType.rawValue)"
    case .topLevelUserCollections:
      return "topLevelUserCollections"
    }
  }
  
  public func hash(into hasher: inout Hasher) {
    hasher.combine(self.identifier)
  }
}

public enum PopupConfigure {
  //Popup album view animation duration
  case animation(TimeInterval)
}

// PHFetchedResultGroupedBy
//
// CGrouped by date, cannot be used prefetch options
// take about few seconds ( 5000 image iPhoneX: 1 ~ 1.5 sec )
//public enum PHFetchedResultGroupedBy {
//    case year
//    case month
//    case week
//    case day
//    case hour
//    case custom(dateFormat: String)
//}

//for log
//public protocol TLPhotosPickerLogDelegate: class {
//    func selectedCameraCell(picker: TLPhotosPickerViewController)
//    func deselectedPhoto(picker: TLPhotosPickerViewController, at: Int)
//    func selectedPhoto(picker: TLPhotosPickerViewController, at: Int)
//    func selectedAlbum(picker: TLPhotosPickerViewController, title: String, at: Int)
//}

////for collection supplement view
//let viewController = TLPhotosPickerViewController()
//func test() {
//  viewController.customDataSouces
//}
//public protocol TLPhotopickerDataSourcesProtocol {
//    func headerReferenceSize() -> CGSize
//    func footerReferenceSize() -> CGSize
//    func registerSupplementView(collectionView: UICollectionView)
//    func supplementIdentifier(kind: String) -> String
//    func configure(supplement view: UICollectionReusableView, section: (title: String, assets: [TLPHAsset]))
//}
