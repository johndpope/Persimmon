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


  private let photoListVC = PhotoListVC()

  private let albumListVC = AlbumListVC()

  private let settingVC = SettingVC()

//  private lazy var navi: UINavigationController = {
//     let navi = UINavigationController(rootViewController: albumListVC)
//     return navi
//   }()

    override func viewDidLoad() {
        super.viewDidLoad()
      setupTabBar()

    }

  private func setupTabBar() {

    installTabBarItems()


    tabBar.tintColor = .appColor(.appFontColor)
    tabBar.backgroundColor = .white
    self.viewControllers = [albumListVC, photoListVC, settingVC]
  }

  private func installTabBarItems() {

    let trashCanItem = UITabBarItem(title: "휴지통", image: nil, tag: 0)
    let albumListVCItem = UITabBarItem(title: "사진첩", image: nil, tag: 1)
    let settingVCItem = UITabBarItem(title: "설정", image: nil, tag: 2)

    photoListVC.tabBarItem = trashCanItem
    albumListVC.tabBarItem = albumListVCItem
    settingVC.tabBarItem = settingVCItem
  }


}
