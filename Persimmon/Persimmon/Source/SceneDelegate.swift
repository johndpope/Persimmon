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
  let vc = PassCodeVC()
//  let vc = TestRealm()

  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    
    // Create the SwiftUI view that provides the window contents.
    
    
    // Use a UIHostingController as window root view controller.
    if let windowScene = scene as? UIWindowScene {
      let window = UIWindow(windowScene: windowScene)
      window.backgroundColor = .appColor(.appYellowColor)
      window.rootViewController = vc
      self.window = window
      window.makeKeyAndVisible()
      
    }
  }
  
  
  
  func sceneDidDisconnect(_ scene: UIScene) {
    print("\n-------------[sceneDidDisconnect]-------------\n")
  }
  
  func sceneDidBecomeActive(_ scene: UIScene) {
    print("\n-------------[sceneDidBecomeActive]-------------\n")
  }
  
  func sceneWillResignActive(_ scene: UIScene) {
    print("\n-------------[sceneWillResignActive]-------------\n")
  }
  
  func sceneWillEnterForeground(_ scene: UIScene) {
    print("\n-------------[sceneWillEnterForeground]-------------\n")
  }
  
  func sceneDidEnterBackground(_ scene: UIScene) {
    print("\n-------------[sceneDidEnterBackground]-------------\n")
    let rootView = PassCodeVC()
    window?.rootViewController = rootView
    window?.makeKeyAndVisible()
  }
  
  
}

