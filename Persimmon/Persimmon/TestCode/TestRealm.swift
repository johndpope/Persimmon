//
//  TestRealm.swift
//  Persimmon
//
//  Created by hyeoktae kwon on 2019/10/12.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import RealmSwift

class TestRealm: UIViewController {
  
  let realm = try! Realm()
  
  lazy var albums = realm.objects(Album.self)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    print("albums Count: ", albums.count, "title: ", albums.first?.title)
    
    try! realm.write {
      let album = Album()
      album.title = "newAlbum"
      realm.add(album)
    }
    
    print("albums Count: ", albums.count, "title: ", albums.first?.title)
    // Do any additional setup after loading the view.
  }
  
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  
}
