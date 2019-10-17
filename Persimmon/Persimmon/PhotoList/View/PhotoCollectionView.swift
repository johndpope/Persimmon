//
//  PhotoCollectionView.swift
//  Persimmon
//
//  Created by hyeoktae kwon on 2019/10/17.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import SnapKit

class PhotoCollectionView: UIView {
  
  let flowLayout: UICollectionViewFlowLayout = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    let scale = UserDefaults.standard.bool(forKey: "scale")
    let count = scale ? CGFloat(3) : CGFloat(4)
    let width = ((UIScreen.main.bounds.width-(5*(count-1)))/count)
//    let width = (UIScreen.main.bounds.width / count).rounded(FloatingPointRoundingRule.towardZero)
    print("width: ", width)
    let itemSize = CGSize(width: width-4, height: width-4)
    RealmSingleton.shared.thumbnailSize = itemSize
    layout.itemSize = itemSize
    return layout
  }()
  
  lazy var collectionView: UICollectionView = {
    let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
    view.showsHorizontalScrollIndicator = true
    view.showsVerticalScrollIndicator = true
    view.isScrollEnabled = true
    view.clipsToBounds = true
    view.delaysContentTouches = true
    view.canCancelContentTouches = true
    view.keyboardDismissMode = .none
    view.contentMode = .scaleToFill
    view.semanticContentAttribute = .unspecified
    view.isUserInteractionEnabled = true
    view.isMultipleTouchEnabled = true
    view.isOpaque = true
    view.clearsContextBeforeDrawing = true
    view.autoresizesSubviews = true
    
    
    if #available(iOS 13.0, *) {
      view.backgroundColor = .systemBackground
    } else {
      view.backgroundColor = .white
    }
    return view
  }()
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.addSubview(collectionView)
    
    collectionView.snp.makeConstraints {
      $0.leading.trailing.top.bottom.equalTo(self)
    }
  }
  
}

//@objc public func registerNib(nibName: String, bundle: Bundle) {
//    self.collectionView.register(UINib(nibName: nibName, bundle: bundle), forCellWithReuseIdentifier: nibName)
//}

//self.collectionView.contentOffset = collection.recentPosition
//
//
//open func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//    if let cell = cell as? TLPhotoCollectionViewCell {
//        cell.endDisplayingCell()
//        cell.stopPlay()
//        if indexPath == self.playRequestID?.indexPath {
//            self.playRequestID = nil
//        }
//    }
//    guard let requestID = self.requestIDs[indexPath] else { return }
//    self.requestIDs.removeValue(forKey: indexPath)
//    self.photoLibrary.cancelPHImageRequest(requestID: requestID)
//}
//
//public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//    guard let cell = cell as? TLPhotoCollectionViewCell else {
//        return
//    }
//    cell.willDisplayCell()
//    if self.usedPrefetch, let collection = self.focusedCollection, let asset = collection.getTLAsset(at: indexPath) {
//        if let selectedAsset = getSelectedAssets(asset) {
//            cell.selectedAsset = true
//            cell.orderLabel?.text = "\(selectedAsset.selectedOrder)"
//        }else{
//            cell.selectedAsset = false
//        }
//    }
//}
