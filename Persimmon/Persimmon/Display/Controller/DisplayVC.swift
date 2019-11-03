//
//  DisplayVC.swift
//  Persimmon
//
//  Created by hyeoktae kwon on 2019/11/02.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit

class DisplayVC: UIViewController {
  
  var model: DisplayModel? {
    didSet {
      displayView.collection.collectionView.delegate = self
      displayView.collection.collectionView.dataSource = self
      displayView.collection.collectionView.scrollToItem(at: model?.selectedCell ?? [], at: .centeredHorizontally, animated: false)
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
  
  override func loadView() {
    self.view = displayView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  
  
  
  // MARK: - Buttons Target Functions
  @objc func didTapGraveBtn(_ sender: UIButton) {
    
  }
  
  @objc func didTapSharedBtn(_ sender: UIButton) {
    
  }
  
  @objc func didTapPlayBtn(_ sender: UIButton) {
    
  }
  
  @objc func didTapMuteBtn(_ sender: UIButton) {
    
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
    
    let photo = object.photos[indexPath.row]
    cell.model = DisplayCellModel(type: photo.type,
                                  image: photo.imageName,
                                  video: photo.videoName,
                                  uuid: photo.photoUUID)
    
    return cell
  }
  
  
}

extension DisplayVC: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    if let cell = cell as? DisplayCollectionCell {
      cell.decelerate = true
    }
  }
  
  
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    
    if let cell = cell as? DisplayCollectionCell {
      cell.setImage()
    }
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
    let cells = displayView.collection.collectionView.visibleCells
    cells.forEach { cell in
      guard let cell = cell as? DisplayCollectionCell else { return }
      cell.decelerate = true
    }
  }

  func scrollingFinished() {
    let cells = displayView.collection.collectionView.visibleCells
    cells.forEach { cell in
      guard let cell = cell as? DisplayCollectionCell else { return }
      cell.decelerate = false
    }
  }
  
}
