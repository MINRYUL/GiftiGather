//
//  BaseCollectionView.swift
//  GiftiGather
//
//  Created by 김민창 on 2022/09/17.
//  Copyright © 2022 GiftiGather. All rights reserved.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
  static var identifier: String {
    return Self.className
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    viewDidInit()
  }
  
  required init?(coder: NSCoder) {
    fatalError("Not implemented required init?(coder: NSCoder)")
  }
  
  static func register(to collectionView: UICollectionView) {
    collectionView.register(Self.self, forCellWithReuseIdentifier: self.identifier)
  }
  
  func viewDidInit() { }
}
