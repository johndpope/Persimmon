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

protocol DisplayCollectionCellDelegate: class {
  @discardableResult
  func didTapShort() -> Bool
  func endPlayVideo()
  func checkCurrentMuteState() -> Bool
  func checkDuration(duration: String)
}

class DisplayCollectionCell: UICollectionViewCell {
  static let identifier = "DisplayCollectionCell"
  
  weak var delegate: DisplayCollectionCellDelegate?
  var timer: Timer?
  var time = 0
  private var endPlayObserver: NSObjectProtocol?
  private var durationObserver: NSObjectProtocol?
  var requestID: PHLivePhotoRequestID?
  
  var decelerate: Bool = true {
    didSet {
//      guard !decelerate,
//        model?.cellType == "live",
//        livePhotoView.livePhoto == nil else { return }
//      self.requestID = self.model?.getLivePhoto(completion: { (live) in
//        self.live = live
//      })
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
//    view.startPlayback(with: .hint)
    view.isMuted = true
    return view
  }()
  
  var playerView: PlayerView = {
    let view = PlayerView()
    view.contentMode = .scaleAspectFit
    return view
  }()
  
  var model: DisplayCellModel?
  
  var live: PHLivePhoto? = nil {
    didSet {
        if self.live == nil {
          self.livePhotoView.stopPlayback()
          self.livePhotoView.livePhoto = nil
          self.livePhotoView.isHidden = true
        } else {
          self.livePhotoView.isHidden = false
          self.livePhotoView.livePhoto = self.live
//          self.livePhotoView.startPlayback(with: .hint)
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
          guard let observer = self.endPlayObserver else { return }
          NotificationCenter.default.removeObserver(observer)
          self.playerView.playerLayer.player = nil
          self.playerView.isHidden = true
        } else {
          self.playerView.isHidden = false
          self.playerView.playerLayer.videoGravity = .resizeAspect
          self.playerView.playerLayer.player = self.playItem
          
          self.endPlayObserver = NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.playItem?.currentItem, queue: nil, using: { [weak self] (_) in
            guard let `self` = self else { return }
            self.playItem?.seek(to: CMTime.zero)
            self.playItem?.isMuted = true
            self.playItem?.pause()
            self.delegate?.endPlayVideo()
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
    self.backgroundColor = .black
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
        self.model?.getThumbnail(completion: { (image) in
          DispatchQueue.main.async {
            self.image = image
          }
        })
      case "live":
        self.requestID = self.model?.getLivePhoto(completion: { (live) in
          self.live = live
        })
      case "video":
        DispatchQueue.main.async {
          guard let video = self.model?.getVideo() else { return }
          self.playItem = video
        }
      default:
        break
      }
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.livePhotoView.stopPlayback()
    if let timer = timer {
      if !timer.isValid {
        self.timer  = Timer.scheduledTimer(timeInterval: -1, target: self, selector: #selector(discount), userInfo: nil, repeats: true)
      }
    } else {
      self.timer  = Timer.scheduledTimer(timeInterval: -1, target: self, selector: #selector(discount), userInfo: nil, repeats: true)
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let timer = timer {
      if(timer.isValid){
        if time >= 0 {
          delegate?.didTapShort()
        }
        time = 1
        self.timer?.invalidate()
      }
    }
  }
  
  @objc func discount() {
    self.time -= 1
  }
  
  func togglePlay(state: Bool) {
    if let palyItem = self.playerView.player {
      state ? palyItem.pause() : palyItem.play()
      self.playerView.player?.isMuted = delegate?.checkCurrentMuteState() ?? true ? false : true
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
    DispatchQueue.main.async {
      self.stopPlay()
      self.endDisplay()
      
    }
    self.live = nil
    self.playItem = nil
    self.image = nil
  }
  
  deinit {
    print("deinit displayCollectionCell@@@")
    stopPlay()
    live = nil
    playItem = nil
    image = nil
  }
  
}
