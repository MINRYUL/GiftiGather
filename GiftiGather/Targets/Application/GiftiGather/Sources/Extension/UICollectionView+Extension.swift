//
//  UICollectionView+Extension.swift
//  GiftiGather
//
//  Created by 김민창 on 2023/02/26.
//  Copyright © 2023 GiftiGather. All rights reserved.
//

import UIKit

extension UICollectionView {
  static func itemHighlighted(collecionView: UICollectionView, indexPath: IndexPath) {
    guard let cell = collecionView.cellForItem(
      at: indexPath
    ) else { return }
    
    let pressedDownTransform = CGAffineTransform(scaleX: 0.96, y: 0.96)
    UIView.animate(
      withDuration: 0.4,
      delay: 0,
      usingSpringWithDamping: 0.4,
      initialSpringVelocity: 3,
      options: [.curveEaseInOut],
      animations: { cell.transform = pressedDownTransform }
    )
  }
  
  static func itemUnhighlighted(collecionView: UICollectionView, indexPath: IndexPath) {
    guard let cell = collecionView.cellForItem(
      at: indexPath
    ) else { return }
    
    let originalTransform = CGAffineTransform(scaleX: 1, y: 1)
    UIView.animate(
      withDuration: 0.4,
      delay: 0,
      usingSpringWithDamping: 0.4,
      initialSpringVelocity: 3,
      options: [.curveEaseInOut],
      animations: { cell.transform = originalTransform }
    )
  }
}
