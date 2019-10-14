//
//  SceneDelegate.swift
//  Persimmon
//
//  Created by hyeoktae kwon on 2019/10/12.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import SwiftUI
import RealmSwift
import Photos
import TLPhotoPicker

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?
//  let vc = AlbumListVC()
//  let vc = PassCodeVC()
//  let vc = TestRealm()
  let vc = TLPhotosPickerViewController()
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    
    // Create the SwiftUI view that provides the window contents.
    
    
    // Use a UIHostingController as window root view controller.
    if let windowScene = scene as? UIWindowScene {
      setupConfigure()
      let window = UIWindow(windowScene: windowScene)
      window.backgroundColor = .white
      window.rootViewController = vc
      self.window = window
      window.makeKeyAndVisible()
      
      
    }
  }
  
  private func setupConfigure() {
    vc.configure.cancelTitle = "취소"
    vc.configure.doneTitle = "완료"
    vc.configure.tapHereToChange = "탭해서 바꾸기"
    vc.configure.emptyMessage = "앨범 없음"
    vc.configure.recordingVideoQuality = .typeHigh
    vc.configure.selectedColor = .appColor(.appPersimmonColor)
//    vc.configure.customLocalizedTitle = ["카메라 롤": "카메라 롤"]
//    vc.configure.cameraBgColor = .appColor(.appPersimmonColor)
    let test = TLPHAsset(asset: PHAsset())
  }
  
  
  func sceneDidDisconnect(_ scene: UIScene) {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
  }
  
  func sceneDidBecomeActive(_ scene: UIScene) {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
  }
  
  func sceneWillResignActive(_ scene: UIScene) {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
  }
  
  func sceneWillEnterForeground(_ scene: UIScene) {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
  }
  
  func sceneDidEnterBackground(_ scene: UIScene) {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
  }
  
  
}

