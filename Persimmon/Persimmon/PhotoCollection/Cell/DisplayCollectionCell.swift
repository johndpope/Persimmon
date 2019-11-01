//
//  DisplayCollectionCell.swift
//  Persimmon
//
//  Created by Jeon-heaji on 2019/10/31.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import AVKit
import PhotosUI

class DisplayCollectionCell: UICollectionViewCell {
  static let identifier = "DisplayCollectionCell"
  
  var cellType: String?
  var imageName: String?
  var videoName: String?
  private var observer: NSObjectProtocol?
  
  var imageView: UIImageView?
  var livePhotoView: PHLivePhotoView?
  var playerView: PlayerView?
  
  var playItem: AVPlayer? = nil {
    didSet {
      if self.playItem == nil {
        self.playerView?.playerLayer.player = nil
        guard let observer = self.observer else { return }
        NotificationCenter.default.removeObserver(observer)
      } else {
        self.playerView?.playerLayer.videoGravity = .resizeAspect
        self.playerView?.playerLayer.player = self.playItem
        self.observer = NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.playItem?.currentItem, queue: nil, using: { [weak self] (_) in
          guard let `self` = self else { return }
          self.playItem?.seek(to: CMTime.zero)
          self.playItem?.isMuted = true
          self.playItem?.pause()
        })
      }
    }
  }
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    self.livePhotoView?.isHidden = true
    if #available(iOS 11.0, *) {
      self.imageView?.accessibilityIgnoresInvertColors = true
      self.playerView?.accessibilityIgnoresInvertColors = true
      self.livePhotoView?.accessibilityIgnoresInvertColors = true
    }
  }
  
  func stopPlay() {
    if let palyItem = self.playItem {
      palyItem.pause()
      self.playItem = nil
    }
    self.livePhotoView?.livePhoto = nil
    self.livePhotoView?.isHidden = true
    self.livePhotoView?.stopPlayback()
    self.livePhotoView?.delegate = nil
    
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    stopPlay()
    
  }
  
  
}
