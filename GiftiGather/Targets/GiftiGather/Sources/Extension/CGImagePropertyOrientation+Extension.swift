//
//  CGImagePropertyOrientation+Extension.swift
//  GiftiGather
//
//  Created by 김민창 on 2022/09/18.
//  Copyright © 2022 GiftiGather. All rights reserved.
//

import Foundation

import UIKit
import ImageIO

extension CGImagePropertyOrientation {
  init(_ orientation: UIImage.Orientation) {
    switch orientation {
      case .up: self = .up
      case .upMirrored: self = .upMirrored
      case .down: self = .down
      case .downMirrored: self = .downMirrored
      case .left: self = .left
      case .leftMirrored: self = .leftMirrored
      case .right: self = .right
      case .rightMirrored: self = .rightMirrored
    }
  }
}
