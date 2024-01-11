//
//  UINavigationController.swift
//  GiftiGather
//
//  Created by 김민창 on 2022/09/17.
//  Copyright © 2022 GiftiGather. All rights reserved.
//

import UIKit

extension UINavigationController {
  var navigationLargeTitleBarColor: UIColor {
    get {
      return self.view.backgroundColor ?? .clear
    }
    set {
      self.view.backgroundColor = newValue
    }
  }
}
