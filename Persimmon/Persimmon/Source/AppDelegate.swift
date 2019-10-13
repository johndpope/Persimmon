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
  //  let vc = PassCodeVC()
  let vc = TestRealm()
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    // realm configuration
    let configBlock: MigrationBlock = { (migration, oldVersion) in
      print("start Migration")
      if oldVersion < 2 {
        migration.enumerateObjects(ofType: Album.className()) { (old, new) in
          // need to migration
          new?["uuid"] = UUID().uuidString
          new?["title"] = "test"
        }
      }
      print("Migration complete.")
    }
    
    Realm.Configuration.defaultConfiguration = Realm.Configuration(schemaVersion: 2, migrationBlock: configBlock)
    
    guard #available(iOS 13.0, *) else {
      
      window = UIWindow(frame: UIScreen.main.bounds)
      window?.rootViewController = vc
      window?.makeKeyAndVisible()
      
      return true }
    
    return true
  }
  
  
  
  //  // realm configuration
  //  let config = Realm.Configuration(schemaVersion: 1, migrationBlock: { (migration, oldVersion) in
  //    print("start Migration")
  //    migration.enumerateObjects(ofType: Album.className()) { (old, new) in
  //      if oldVersion < 1 {
  //        // need to migration
  //        new?["uuid"] = UUID().uuidString
  //      }
  //    }
  //    print("Migration complete.")
  //  })
  
  
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

