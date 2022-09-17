//
//  BaseTableViewCell.swift
//  GiftiGather
//
//  Created by 김민창 on 2022/09/17.
//  Copyright © 2022 GiftiGather. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
  static var identifier: String {
    return Self.className
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    self.viewDidInit()
  }
  
  required init?(coder: NSCoder) {
    fatalError("Not implemented required init?(coder: NSCoder)")
  }
  
  static func register(to tableView: UITableView) {
    tableView.register(Self.self, forCellReuseIdentifier: self.identifier)
  }
  
  func viewDidInit() { }
}
