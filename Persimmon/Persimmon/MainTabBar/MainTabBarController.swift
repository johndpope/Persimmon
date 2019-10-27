//
//  MainTabBarController.swift
//  Persimmon
//
//  Created by Jeon-heaji on 2019/10/14.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//
//
import UIKit

class MainTabBarController: UITabBarController {


  private let photoGraveVC = PhotoGraveVC()

  private let albumListVC = AlbumListVC()

  private let settingVC = SettingVC()
  

  private lazy var navi: UINavigationController = {
     let navi = UINavigationController(rootViewController: settingVC)
     return navi
   }()

    override func viewDidLoad() {
        super.viewDidLoad()
      setupTabBar()

    }

   func setupTabBar() {

    installTabBarItems()


    tabBar.tintColor = .appColor(.appFontColor)
    tabBar.backgroundColor = .appColor(.appGreenColor)
    self.setViewControllers([albumListVC, photoGraveVC, settingVC], animated: true)
//    self.viewControllers = [albumListVC, photoGraveVC, settingVC]
  }

  private func installTabBarItems() {
    let albumListVCItem = UITabBarItem(title: "사진첩", image: UIImage(named: "gallery"), tag: 0)
    let trashCanItem = UITabBarItem(title: "휴지통", image: UIImage(named: "garbage"), tag: 1)
    let settingVCItem = UITabBarItem(title: "설정", image: UIImage(named: "settings"), tag: 2)
    
    albumListVC.tabBarItem = albumListVCItem
    photoGraveVC.tabBarItem = trashCanItem
    settingVC.tabBarItem = settingVCItem
  }


}
