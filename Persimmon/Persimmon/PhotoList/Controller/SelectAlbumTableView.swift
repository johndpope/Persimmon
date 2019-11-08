//
//  SelectAlbumTableVC.swift
//  Persimmon
//
//  Created by hyeoktae kwon on 2019/10/28.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import SnapKit

class SelectAlbumTableView: UIView {
  
  let albums = RealmSingleton.shared.albums
  
  let tableView: UITableView = {
    let view = UITableView()
    view.register(AlbumListTableCell.self, forCellReuseIdentifier: AlbumListTableCell.identifier)
    return view
  }()
  
  // MARK: - Table view data source
  override func layoutSubviews() {
    super.layoutSubviews()
    addSubview(tableView)
    setupSNP()
    tableView.dataSource = self
  }
  
  func setupSNP() {
    tableView.snp.makeConstraints {
      $0.top.bottom.leading.trailing.equalToSuperview()
    }
  }
  
  
}


extension SelectAlbumTableView: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return albums.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: AlbumListTableCell.identifier, for: indexPath) as! AlbumListTableCell
    
    cell.selectionStyle = .none
    cell.titleLabel.text = albums[indexPath.row].title
    cell.subTitleLabel.text = "[ \(albums[indexPath.row].photos.count.description) ]"
    cell.albumImageView.contentMode = .scaleAspectFill
    cell.albumUUID = albums[indexPath.row].albumUUID
    
    guard let lastPhoto = albums[indexPath.row].photos.last,
      let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first,
      let imageData = try? Data(contentsOf: url.appendingPathComponent("\(lastPhoto.photoUUID)/\(lastPhoto.thumbnail)")) else {
        cell.albumImageView.image = UIImage(named: "persimmonIcon")
        return cell
        
    }
    
    cell.albumImageView.image = UIImage(data: imageData)
    return cell
  }
  
  
}