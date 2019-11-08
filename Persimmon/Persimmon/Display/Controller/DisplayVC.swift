//
//  DisplayVC.swift
//  Persimmon
//
//  Created by hyeoktae kwon on 2019/11/02.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import Photos
import AVKit

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
    view.slider.addTarget(self, action: #selector(progressSliderValueChanged(_:)), for: .valueChanged)
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
    if cell.livePhotoView.livePhoto != nil {
      cell.livePhotoView.isMuted.toggle()
      sender.isSelected.toggle()
    }
    if cell.playerView.player != nil {
      cell.playerView.player?.isMuted.toggle()
      sender.isSelected.toggle()
    }
  }
  
  @objc func didTapBackBtn(_ sender: UIButton) {
    navigationController?.popViewController(animated: true)
  }
  @objc private func progressSliderValueChanged(_ sender: UISlider) {
    guard !sender.isHidden else { return }
    guard let cell = self.displayView.collection.collectionView.visibleCells.first as? DisplayCollectionCell else { return }
    guard let duration = cell.playerView.player?.currentItem?.duration else { return }
    let value = Float64(sender.value) * CMTimeGetSeconds(duration)
    guard !value.isNaN else { return }
    let seekTime = CMTime(value: CMTimeValue(value), timescale: 1)
    cell.playerView.player?.seek(to: seekTime)
    
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
    
    cell.setImage()
    return cell
  }
  
  
}

extension DisplayVC: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    if let cell = cell as? DisplayCollectionCell {
      DispatchQueue.main.async {
        cell.decelerate = true
        cell.delegate = nil
        cell.stopPlay()
      }
      
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    if let cell = cell as? DisplayCollectionCell {
      cell.setImage()
      cell.delegate = self
      cell.livePhotoView.isMuted = true
      cell.playerView.player?.isMuted = true
      self.displayView.bottomView.muteBtn.isSelected = false
      self.displayView.bottomView.playBtn.isSelected = false
    }
    model?.lastIndex = indexPath
  }
  
}


extension DisplayVC: DisplayCollectionCellDelegate {
  func checkDuration(duration: String) {
    ()
  }
  
  func checkCurrentMuteState() -> Bool {
    return self.displayView.bottomView.muteBtn.isSelected
  }
  
  func endPlayVideo() {
    self.displayView.bottomView.playBtn.isSelected = false
    self.displayView.bottomView.muteBtn.isSelected = false
  }
  
  func didTapShort() -> Bool {
    showState ? displayView.hidePanel() : displayView.showPanel()
    showState.toggle()
    return !showState
  }
}
  


//extension DisplayVC: UICollectionViewDataSourcePrefetching {
//  func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
//    print("in prefetch")
//
//    indexPaths.forEach { index in
//      guard let cell = collectionView.cellForItem(at: index) as? DisplayCollectionCell, cell.model?.cellType == "live" else { return }
//      print("aslkegnleskgn")
//      DispatchQueue.global(qos: .userInteractive).async {
//        cell.model?.getLivePhoto(completion: { (live) in
//          cell.livePhotoView.livePhoto = live
//        })
//      }
//    }
//  }
//
//
//}