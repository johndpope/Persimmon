
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
  func updateSlider(value: Float)
  func updateDuration(duration: String)
}

class DisplayCollectionCell: UICollectionViewCell {
  static let identifier = "DisplayCollectionCell"
  
  weak var delegate: DisplayCollectionCellDelegate?
  var timer: Timer?
  var time = 0
  private var endPlayObserver: NSObjectProtocol?
  private var durationObserver: Any?
  var requestID: PHLivePhotoRequestID?
  
  var decelerate: Bool = true {
    didSet {
      guard !decelerate else { return }
      switch self.model?.cellType {
      case "image":
        DispatchQueue.global(qos: .userInitiated).async {
          guard let image = self.model?.getImage() else { return }
          DispatchQueue.main.async {
            self.image = image
          }
        }
      case "live":
        DispatchQueue.global(qos: .userInitiated).async {
          self.model?.getLivePhoto(completion: { (live) in
            DispatchQueue.main.async {
              self.live = live
              self.imageView.isHidden = true
              
            }
          })
        }
      default:
        break
      }
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
  
  let livePhotoBadgeView: UIImageView = {
    let option = PHLivePhotoBadgeOptions.overContent
    let badge = PHLivePhotoView.livePhotoBadgeImage(options: option)
    let iv = UIImageView(image: badge)
    iv.contentMode = .scaleAspectFit
    iv.clipsToBounds = true
    return iv
  }()
  
  var playerView: PlayerView = {
    let view = PlayerView()
    view.contentMode = .scaleAspectFit
    return view
  }()
  
  var model: DisplayCellModel? {
    didSet {
      switch self.model?.cellType {
      case "video":
          guard let video = self.model?.getVideo() else { return }
            self.playItem = video
      default:
        self.model?.getThumbnail(completion: { (image) in
          DispatchQueue.main.async {
            self.image = image
          }
        })
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
          self.playerView.playerLayer.player = nil
          self.playerView.isHidden = true
          guard let observer = self.endPlayObserver else { return }
          NotificationCenter.default.removeObserver(observer)
          self.playerView.player?.removeTimeObserver(self.durationObserver as Any)
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
  
  func addDurationObserver() {
    let interval = CMTime(seconds: 0.01, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
    
    self.durationObserver = playerView.player?.addPeriodicTimeObserver(forInterval: interval, queue: .main, using: { (time) in
      self.updateVideoPlayerSlider()
    })
  }
  
  func removeDurationObserver() {
    self.durationObserver = nil
  }
  
  private func updateVideoPlayerSlider() {
    guard let currentTime = playerView.player?.currentTime() else { return }
    let currentTimeInSeconds = CMTimeGetSeconds(currentTime)
//    playerView.progressSliderValue = Float(currentTimeInSeconds)
    delegate?.updateSlider(value: Float(currentTimeInSeconds))
    if let currentItem = playerView.player?.currentItem {
      let duration = currentItem.duration
      if CMTIME_IS_INVALID(duration) {
        return
      }
      let currentTime = currentItem.currentTime()
//      playerView.progressSliderValue = Float(CMTimeGetSeconds(currentTime) / CMTimeGetSeconds(duration))
      delegate?.updateSlider(value: Float(CMTimeGetSeconds(currentTime) / CMTimeGetSeconds(duration)))
      // Update time remaining Label
      let totalTimeInSeconds = CMTimeGetSeconds(duration)
      let remainingTimeInSeconds = totalTimeInSeconds - currentTimeInSeconds
      
      let mins = remainingTimeInSeconds / 60
      let secs = remainingTimeInSeconds.truncatingRemainder(dividingBy: 60)
      let timeFormatter = NumberFormatter()
      
      timeFormatter.minimumIntegerDigits = 2
      timeFormatter.minimumFractionDigits = 0
      timeFormatter.roundingMode = .down
      guard let minsString = timeFormatter.string(from: NSNumber(value: mins)), let secsString = timeFormatter.string(from: NSNumber(value: secs)) else { return }
//      playerView.timeLabelText = "\(minsString):\(secsString)"
      delegate?.updateDuration(duration: "\(minsString):\(secsString)")
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
    livePhotoView.addSubview(livePhotoBadgeView)
    self.livePhotoView.startPlayback(with: .hint)
    self.livePhotoView.delegate = self
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
    
    livePhotoBadgeView.snp.makeConstraints {
      $0.width.height.equalTo(28.i)
      $0.top.equalToSuperview().offset((UIScreen.main.bounds.height / 15))
      $0.trailing.equalToSuperview().offset(-10.i)
    }
    
  }
  
  func setPlayer() {
      switch self.model?.cellType {
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
  
  func endDisplay() {
    if let id = requestID {
      PHLivePhoto.cancelRequest(withRequestID: id)
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
    self.delegate = nil
  }
  
  deinit {
    print("deinit displayCollectionCell@@@")
    stopPlay()
    live = nil
    playItem = nil
    image = nil
  }
  
}

extension DisplayCollectionCell: PHLivePhotoViewDelegate {
  func livePhotoView(_ livePhotoView: PHLivePhotoView, didEndPlaybackWith playbackStyle: PHLivePhotoViewPlaybackStyle) {
    livePhotoBadgeView.alpha = 1
  }
  
  func livePhotoView(_ livePhotoView: PHLivePhotoView, willBeginPlaybackWith playbackStyle: PHLivePhotoViewPlaybackStyle) {
    livePhotoBadgeView.alpha = 0
  }
}
