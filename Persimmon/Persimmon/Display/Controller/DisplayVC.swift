//
//  DisplayVC.swift
//  Persimmon
//
//  Created by hyeoktae kwon on 2019/11/02.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import Photos

class DisplayVC: UIViewController {
  
  var showState: Bool = true
  var model: DisplayModel? {
    didSet {
      model?.asyncPrefetchTempPhotos()
      displayView.collection.collectionView.delegate = self
      displayView.collection.collectionView.dataSource = self
//      displayView.collection.collectionView.prefetchDataSource = self
    }
  }
  
  lazy var displayView: DisplayView = {
    let view = DisplayView()
    view.bottomView.graveBtn.addTarget(self, action: #selector(didTapGraveBtn(_:)), for: .touchUpInside)
    view.bottomView.playBtn.addTarget(self, action: #selector(didTapPlayBtn(_:)), for: .touchUpInside)
    view.bottomView.muteBtn.addTarget(self, action: #selector(didTapMuteBtn(_:)), for: .touchUpInside)
    view.topView.backBtn.addTarget(self, action: #selector(didTapBackBtn(_:)), for: .touchUpInside)
    view.topView.sharedBtn.addTarget(self, action: #selector(didTapSharedBtn(_:)), for: .touchUpInside)
    return view
  }()
  
  override func viewDidLoad() {
    self.view.addSubview(displayView)
    displayView.snp.makeConstraints {
      $0.leading.top.bottom.trailing.equalToSuperview()
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    view.layoutIfNeeded()
    displayView.collection.collectionView.scrollToItem(at: model?.selectedCell ?? [], at: .centeredHorizontally, animated: false)
  }
  
  
  // MARK: - Buttons Target Functions
  @objc func didTapGraveBtn(_ sender: UIButton) {
    
  }
  
  @objc func didTapSharedBtn(_ sender: UIButton) {
    
  }
  
  @objc func didTapPlayBtn(_ sender: UIButton) {
    guard let cell = displayView.collection.collectionView.visibleCells.first as? DisplayCollectionCell else { return }
    cell.togglePlay(state: sender.isSelected)
    sender.isSelected.toggle()
  }
  
  @objc func didTapMuteBtn(_ sender: UIButton) {
    guard let cell = displayView.collection.collectionView.visibleCells.first as? DisplayCollectionCell else { return }
    guard cell.livePhotoView.livePhoto != nil else { return }
    cell.livePhotoView.isMuted.toggle()
    sender.isSelected.toggle()
  }
  
  @objc func didTapBackBtn(_ sender: UIButton) {
    navigationController?.popViewController(animated: true)
  }
  
  
  
}


extension DisplayVC: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return model?.object?.photos.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DisplayCollectionCell.identifier, for: indexPath) as! DisplayCollectionCell
    guard let object = model?.object else { return cell }
    
    cell.playerView.isHidden = true
    cell.livePhotoView.isHidden = true
    cell.imageView.isHidden = true
    
    cell.backgroundColor = !showState ? .black : .appColor(.appGreenColor)
    
    let photo = object.photos[indexPath.row]
    cell.model = DisplayCellModel(type: photo.type,
                                  image: photo.imageName,
                                  video: photo.videoName,
                                  uuid: photo.photoUUID)
    print("currentCellIndex: ", indexPath)
    switch photo.type {
    case "live":
      if let photo = model?.tempPhotos[indexPath] {
        if photo.0 {
          cell.live = photo.1 as? PHLivePhoto
        }
      } else {
        cell.model?.getLivePhoto(completion: { (live) in
          cell.live = live
        })
      }
    case "video":
      if let photo = model?.tempPhotos[indexPath] {
        if photo.0 {
          cell.playItem = photo.1 as? AVPlayer
        }
      } else {
        cell.playItem = cell.model?.getVideo()
      }
    case "image":
      if let photo = model?.tempPhotos[indexPath] {
        if photo.0 {
          cell.image = photo.1 as? UIImage
        }
      } else {
        cell.image = cell.model?.getImage()
      }
    default:
      break
    }
    
    return cell
  }
  
  
}

extension DisplayVC: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    if let cell = cell as? DisplayCollectionCell {
      cell.delegate = nil
      cell.stopPlay()
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    if let cell = cell as? DisplayCollectionCell {
      cell.backgroundColor  = !showState ? .black : .appColor(.appGreenColor)
      cell.delegate = self
      self.displayView.bottomView.muteBtn.isSelected = false
      self.displayView.bottomView.playBtn.isSelected = false
    }
    model?.lastIndex = indexPath
  }
  
}


extension DisplayVC: DisplayCollectionCellDelegate {
  func didTapShort() -> Bool {
    showState ? displayView.hidePanel() : displayView.showPanel()
    showState.toggle()
    return !showState
  }
}
