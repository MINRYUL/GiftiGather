//
//  UIColor+Extension.swift
//  GiftiGather
//
//  Created by 김민창 on 2022/09/17.
//  Copyright © 2022 GiftiGather. All rights reserved.
//

import UIKit

extension UIColor {
  static var background: UIColor {
    return UIColor(named: "Background") ?? .clear
  }
  
  static var navigationBackground: UIColor {
    return UIColor(named: "NavigationBackground") ?? .clear
  }
  
  static var selectedBackground: UIColor {
    return UIColor(named: "SelectedBackground") ?? .clear
  }
}
