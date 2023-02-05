//
//  BaseCollectionView.swift
//  GiftiGather
//
//  Created by 김민창 on 2022/09/17.
//  Copyright © 2022 GiftiGather. All rights reserved.
//

import UIKit
import Presentation

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
  
  static func dequeueReusableCell<
    cellInterface: BaseCollectionViewCell
  >(
    _ cellType: cellInterface.Type,
    collectionView: UICollectionView,
    withReuseIdentifier: String,
    forIndexPath: IndexPath
  ) -> cellInterface {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: withReuseIdentifier,
      for: forIndexPath
    ) as? cellInterface else {
      fatalError("Cell does not exist.")
    }
    return cell
  }
}
