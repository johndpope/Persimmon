//
//  PhotoGraveVC.swift
//  Persimmon
//
//  Created by hyeoktae kwon on 2019/10/23.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import Photos
import TLPhotoPicker
import RealmSwift
import SnapKit

class PhotoGraveVC: UIViewController {
  let photoGraveView = PhotoGraveView()
  let popUpView = PopUpView(frame: .zero, modify: "복원")
  let object = RealmSingleton.shared.takeGrave()
  var selectedPhotos = [SelectedPhoto]()
  var collectionView: UICollectionView {
    return photoGraveView.collection.collectionView
  }
  
  var selectBtnState: Bool {
    return photoGraveView.countView.selectBtn.isSelected
  }
  
  override func loadView() {
    self.view = photoGraveView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.collectionView.reloadData()
    self.photoGraveView.countView.listNumberLabel.text = self.takeSubTitle()
  }
  
  private func takeSubTitle() -> String {
    let totalCount = object.photos.count
    let videoCount = object.photos.filter("type = 'video'").count
    let photoCount = totalCount - videoCount
    return "\(photoCount) Photos, \(videoCount) videos"
    
  }
  
  private func setupView() {
    self.photoGraveView.countView.addSubview(popUpView)
    setupSNP()
    collectionView.delegate = self
    collectionView.dataSource = self
    photoGraveView.countView.selectBtn.addTarget(self, action: #selector(didTapSelectBtn(_:)), for: .touchUpInside)
    popUpView.cancelBtn.addTarget(self, action: #selector(didTapCancelBtn(_:)), for: .touchUpInside)
    popUpView.deleteBtn.addTarget(self, action: #selector(didTapDeleteBtn(_:)), for: .touchUpInside)
    popUpView.modifyBtn.addTarget(self, action: #selector(didTapModifyBtn(_:)), for: .touchUpInside)
    self.photoGraveView.countView.listNumberLabel.text = self.takeSubTitle()
  }
  
  private func setupSNP() {
    popUpView.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.height.equalToSuperview()
      $0.trailing.equalToSuperview().offset(200)
      $0.width.equalToSuperview().multipliedBy(0.25)
    }
  }
  
  @objc func didTapSelectBtn(_ sender: UIButton) {
    self.popUpView.snp.remakeConstraints {
      $0.top.equalToSuperview()
      $0.height.equalToSuperview()
      $0.trailing.equalToSuperview().offset(-5)
      $0.width.equalToSuperview().multipliedBy(0.25)
    }
    photoGraveView.countView.selectBtn.isHidden.toggle()
    photoGraveView.countView.selectBtn.isEnabled.toggle()
    photoGraveView.countView.selectBtn.isSelected.toggle()
    popUpView.isHidden = false
  }
  
  @objc func didTapCancelBtn(_ sender: UIButton) {
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
    hiddenPopUpView()
  }
  
  private func hiddenPopUpView() {
    self.popUpView.snp.remakeConstraints {
      $0.top.equalToSuperview()
      $0.height.equalToSuperview()
      $0.trailing.equalToSuperview().offset(200)
      $0.width.equalToSuperview().multipliedBy(0.25)
    }
    photoGraveView.countView.selectBtn.isHidden.toggle()
    photoGraveView.countView.selectBtn.isEnabled.toggle()
    photoGraveView.countView.selectBtn.isSelected.toggle()
    popUpView.isHidden = true
    selectedPhotos = []
    
  }
  
}

extension PhotoGraveVC: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return object.photos.count
    
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
    cell.liveBadgeImageView?.image = nil
    cell.isCameraCell = false
    
    let photo = object.photos[indexPath.row]
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


extension PhotoGraveVC: UICollectionViewDelegate {
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
