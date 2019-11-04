//
//  DisplayCollectionView.swift
//  Persimmon
//
//  Created by Jeon-heaji on 2019/10/31.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import SnapKit

class DisplayCollectionView: UIView {
  
  let flowLayout: UICollectionViewFlowLayout = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    let safeArea = (UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0) + (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0)
    print("safe Area insets: ", safeArea)
    let height = UIScreen.main.bounds.height - safeArea
    let width = UIScreen.main.bounds.width
    let itemSize = CGSize(width: width, height: height)
//    layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    layout.itemSize = itemSize
    layout.minimumInteritemSpacing = 0
    layout.minimumLineSpacing = 0
    return layout
  }()
  
  lazy var collectionView: UICollectionView = {
    let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
    view.showsHorizontalScrollIndicator = false
    view.showsVerticalScrollIndicator = false
    view.isScrollEnabled = true
    view.clipsToBounds = true
    view.isPagingEnabled = true
    view.delaysContentTouches = true
    view.canCancelContentTouches = false
    view.keyboardDismissMode = .none
    view.contentMode = .scaleAspectFit
    view.semanticContentAttribute = .unspecified
    view.isUserInteractionEnabled = true
    view.isMultipleTouchEnabled = false
    view.isOpaque = true
    view.isPrefetchingEnabled = true
    view.clearsContextBeforeDrawing = false
    view.autoresizesSubviews = true
    view.register(DisplayCollectionCell.self, forCellWithReuseIdentifier: DisplayCollectionCell.identifier)
    if #available(iOS 13.0, *) {
      view.backgroundColor = .black
    } else {
      view.backgroundColor = .black
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
