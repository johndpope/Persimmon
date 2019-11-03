//
//  PhotoGraveView.swift
//  Persimmon
//
//  Created by hyeoktae kwon on 2019/10/23.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit

class PhotoGraveView: UIView {
  let countView: CountView = {
    let view = CountView()
    return view
  }()
  
  let collection: PhotoCollectionView = {
    let view = PhotoCollectionView()
    return view
  }()
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.backgroundColor = .appColor(.appLayerBorderColor)
    addSubViews()
    setupSNP()
  }
  
  private func addSubViews() {
    [countView, collection]
      .forEach { self.addSubview($0) }
  }
  
  private func setupSNP() {
    countView.snp.makeConstraints {
      $0.leading.trailing.equalTo(self)
      $0.top.equalTo(self.safeAreaLayoutGuide)
      $0.bottom.equalTo(collection.snp.top)
      $0.height.equalTo(self).multipliedBy(0.08)
    }
    
    collection.snp.makeConstraints {
      $0.leading.trailing.equalTo(self)
      $0.bottom.equalTo(self.safeAreaLayoutGuide)
    }
    
  }
  
  deinit {
    print("deinit CountView")
  }
  
}
