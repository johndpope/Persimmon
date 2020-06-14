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
//      model?.asyncPrefetchTempPhotos()
      collection.delegate = self
      collection.dataSource = self
//      displayView.collection.collectionView.prefetchDataSource = self
    }
  }
  
  var collection: UICollectionView {
    return displayView.collection.collectionView
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
    collection.scrollToItem(at: model?.selectedCell ?? [], at: .centeredHorizontally, animated: false)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    guard let object = model?.object else { return }
    let photo = object.photos[model?.selectedCell.row ?? 0]
    print(photo.type)
    let state = photo.type == "video"
    
    if state {
      guard let cell = collection.visibleCells.first as? DisplayCollectionCell else { return }
      cell.decelerate = false
      cell.delegate = self
      guard let index = collection.indexPath(for: cell) else { return }
      let photo = model?.object?.photos[index.row]
      self.displayView.duration.text = photo?.duration
      cell.addDurationObserver()
    }
    
    displayView.isVideo = state
  }
  
  
  // MARK: - Buttons Target Functions
  @objc func didTapGraveBtn(_ sender: UIButton) {
    guard let object = model?.object else { return }
    guard let uuid = self.model?.albumUUID else { return }
    guard let idx = collection.indexPathsForVisibleItems.first else { return }
    let photos = object.photos
    if photos.indices.contains(idx.row - 1) {
      collection.scrollToItem(at: [0, idx.row - 1], at: .centeredHorizontally, animated: false)
      RealmSingleton.shared.moveToOther(from: uuid, arr: [idx.row])
    } else if photos.indices.contains(idx.row + 1) {
      collection.scrollToItem(at: [0, idx.row + 1], at: .centeredHorizontally, animated: false)
      RealmSingleton.shared.moveToOther(from: uuid, arr: [idx.row])
    } else {
      RealmSingleton.shared.moveToOther(from: uuid, arr: [idx.row])
      self.navigationController?.popViewController(animated: true)
    }
    
  }
  
  @objc func didTapSharedBtn(_ sender: UIButton) {
    
  }
  
  @objc func didTapPlayBtn(_ sender: UIButton) {
    guard let cell = collection.visibleCells.first as? DisplayCollectionCell else { return }
    cell.togglePlay(state: sender.isSelected)
    sender.isSelected.toggle()
  }
  
  @objc func didTapMuteBtn(_ sender: UIButton) {
    guard let cell = collection.visibleCells.first as? DisplayCollectionCell else { return }
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
    guard let cell = self.collection.visibleCells.first as? DisplayCollectionCell else { return }
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
//    self.displayView.hideSlider()
    cell.playerView.isHidden = true
    cell.livePhotoView.isHidden = true
    cell.imageView.isHidden = true
    let photo = object.photos[indexPath.row]
    cell.model = DisplayCellModel(type: photo.type,
                                  image: photo.imageName,
                                  video: photo.videoName,
                                  uuid: photo.photoUUID)
    
//    switch photo.type {
//    case "live":
//      if let photo = model?.tempPhotos[indexPath] {
//        if photo.0 {
//          cell.live = photo.1 as? PHLivePhoto
//        }
//      } else {
//        cell.model?.getLivePhoto(completion: { (live) in
//          cell.live = live
//        })
//      }
//    case "video":
//      if let photo = model?.tempPhotos[indexPath] {
//        if photo.0 {
//          cell.playItem = photo.1 as? AVPlayer
//        }
//      } else {
//        cell.playItem = cell.model?.getVideo()
//      }
//    case "image":
//      if let photo = model?.tempPhotos[indexPath] {
//        if photo.0 {
//          cell.image = photo.1 as? UIImage
//        }
//      } else {
//        cell.image = cell.model?.getImage()
//      }
//    default:
//      break
//    }
    
//    cell.setImage()
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
      cell.setPlayer()
//      cell.delegate = self
      cell.livePhotoView.isMuted = true
      cell.playerView.player?.isMuted = true
      self.displayView.bottomView.muteBtn.isSelected = false
      self.displayView.bottomView.playBtn.isSelected = false
      self.displayView.slider.setValue(0, animated: false)
    }
//    model?.lastIndex = indexPath
  }
  
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    scrollingNotFinish()
  }
  
  func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
    scrollingNotFinish()
  }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    scrollingFinished()
  }
  
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    if decelerate {
      return
    }
    else {
      scrollingFinished()
    }
  }
  
  func scrollingNotFinish() {
    let cells = collection.visibleCells
    cells.forEach { cell in
      guard let cell = cell as? DisplayCollectionCell else { return }
      cell.decelerate = true
//      cell.delegate = nil
    }
  }
  
  func scrollingFinished() {
    
    guard let cell = collection.visibleCells.first as? DisplayCollectionCell else { return }
    cell.decelerate = false
    cell.delegate = self
    if cell.model?.cellType == "video" {
      displayView.isVideo = true
      guard let index = collection.indexPath(for: cell) else { return }
      let photo = model?.object?.photos[index.row]
      self.displayView.duration.text = photo?.duration
      self.displayView.showSlider()
      cell.addDurationObserver()
    } else {
      displayView.isVideo = false
      cell.removeDurationObserver()
    }
  }
  
}


extension DisplayVC: DisplayCollectionCellDelegate {
  func updateSlider(value: Float) {
    self.displayView.slider.value = value
  }
  
  func updateDuration(duration: String) {
    self.displayView.duration.text = duration
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
