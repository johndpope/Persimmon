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
  private var observer: NSObjectProtocol?
  var requestID: PHLivePhotoRequestID?
  
  var decelerate: Bool = true {
    didSet {
      print("state ", decelerate)
      guard !decelerate,
        model?.cellType == "live",
        livePhotoView.livePhoto == nil else { return }
//      self.playItem = nil
//      self.image = nil
      self.requestID = self.model?.getLivePhoto(completion: { (live) in
        self.live = live
      })
    }
  }
  
  var imageView: UIImageView = {
    let view = UIImageView()
    view.contentMode = .scaleAspectFit
    return view
  }()
  
  var livePhotoView: PHLivePhotoView = {
    let view = PHLivePhotoView()
    view.contentMode = .scaleAspectFit
    view.startPlayback(with: .hint)
    view.isMuted = true
    return view
  }()
  
  var playerView: PlayerView = {
    let view = PlayerView()
    view.contentMode = .scaleAspectFit
    return view
  }()

  var model: DisplayCellModel? {
    didSet {
      if model?.cellType == "live" {
        guard let image = self.model?.getImage() else { return }
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        self.backgroundView = imageView
      } else {
        self.backgroundView = nil
      }
    }
  }
  
  var live: PHLivePhoto? = nil {
    didSet {
        if self.live == nil {
          self.livePhotoView.stopPlayback()
          self.livePhotoView.livePhoto = nil
          self.livePhotoView.isHidden = true
        } else {
          self.livePhotoView.isHidden = false
          self.livePhotoView.livePhoto = self.live
          self.livePhotoView.startPlayback(with: .hint)
        }
      
    }
  }
  
  var image: UIImage? = nil {
    didSet {
        if self.image == nil {
          self.imageView.image = nil
          self.imageView.isHidden = true
        } else {
          self.imageView.image = self.image
          self.imageView.isHidden = false
        }
      
    }
  }
  
  var playItem: AVPlayer? = nil {
    didSet {
        if self.playItem == nil {
          guard let observer = self.observer else { return }
          NotificationCenter.default.removeObserver(observer)
          self.playerView.playerLayer.player = nil
          self.playerView.isHidden = true
        } else {
          self.playerView.isHidden = false
          self.playerView.playerLayer.videoGravity = .resizeAspect
          self.playerView.playerLayer.player = self.playItem
          
          self.observer = NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.playItem?.currentItem, queue: nil, using: { [weak self] (_) in
            guard let `self` = self else { return }
            self.playItem?.seek(to: CMTime.zero)
            self.playItem?.isMuted = true
            self.playItem?.pause()
          })
      }
      
      
    }
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    setupSNP()
  }
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    self.backgroundColor = .appColor(.appGreenColor)
    [imageView, livePhotoView, playerView].forEach {
      self.contentView.addSubview($0)
    }
    self.livePhotoView.startPlayback(with: .hint)
    if #available(iOS 11.0, *) {
      self.imageView.accessibilityIgnoresInvertColors = true
      self.playerView.accessibilityIgnoresInvertColors = true
      self.livePhotoView.accessibilityIgnoresInvertColors = true
    }
  }
  
  private func setupSNP() {
    imageView.snp.makeConstraints {
      $0.leading.trailing.top.bottom.equalToSuperview()
    }
    
    livePhotoView.snp.makeConstraints {
      $0.leading.trailing.top.bottom.equalToSuperview()
    }

    playerView.snp.makeConstraints {
      $0.leading.trailing.top.bottom.equalToSuperview()
    }
    
  }
  
  func setImage() {
      switch self.model?.cellType {
      case "image":
//        self.playItem = nil
//        self.live = nil
        guard let image = self.model?.getImage() else { return }
        self.image = image
//      case "live":
//        guard !decelerate else { return }
////        self.playItem = nil
////        self.image = nil
//        self.requestID = self.model?.getLivePhoto(completion: { (live) in
//          self.live = live
//        })
      case "video":
//        self.live = nil
//        self.image = nil
        guard let video = self.model?.getVideo() else { return }
        self.playItem = video
      default:
        break
      }
      
    
  }
  
  func endDisplay() {
    if let id = requestID {
      PHLivePhoto.cancelRequest(withRequestID: id)
    }
  }
  
  func togglePlay(state: Bool) {
    if let palyItem = self.playItem {
      state ? palyItem.play() : palyItem.pause()
    }
  }
  
  func stopPlay() {
    if let palyItem = self.playItem {
      palyItem.pause()
      self.playItem = nil
    }
    self.livePhotoView.stopPlayback()
    
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    stopPlay()
    endDisplay()
    live = nil
    playItem = nil
    image = nil
  }
  
  deinit {
    print("deinit displayCollectionCell@@@")
    stopPlay()
    endDisplay()
    live = nil
    playItem = nil
    image = nil
    model = nil
  }
  
}
