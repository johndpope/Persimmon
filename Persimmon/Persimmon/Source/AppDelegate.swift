//
//  AppDelegate.swift
//  Persimmon
//
//  Created by hyeoktae kwon on 2019/10/12.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  static var instance: AppDelegate {
    return (UIApplication.shared.delegate as! AppDelegate)
  }

  
    let vc = PassCodeVC()
  //  let vc = TestRealm()
//  let vc = AlbumListVC()
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    guard #available(iOS 13.0, *) else {
      Realm.Configuration.defaultConfiguration = config
      window = UIWindow(frame: UIScreen.main.bounds)
      window?.rootViewController = vc
      window?.makeKeyAndVisible()
      
      
      return true }
    
    return true
  }
  
  func checkPassCodeState() {
     let passCodeVC = PassCodeVC()
     let passCodeNavi = UINavigationController(rootViewController: passCodeVC)

     self.window = UIWindow(frame: UIScreen.main.bounds)
     window?.backgroundColor = .white
     window?.rootViewController = passCodeNavi
     window?.makeKeyAndVisible()
   }
  

  
  
  
  // MARK: UISceneSession Lifecycle
  
  @available(iOS 13.0, *)
  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }
  
  @available(iOS 13.0, *)
  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
  }
  
  
}

