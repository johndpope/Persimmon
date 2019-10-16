//
//  PhotoCollectionView.swift
//  Persimmon
//
//  Created by hyeoktae kwon on 2019/10/17.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit

class PhotoCollectionView: UIView {
  
  let flowLayout: UICollectionViewFlowLayout = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    return layout
  }()
  
  lazy var collectionView: UICollectionView = {
    let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
    
    return view
  }()
  
}
