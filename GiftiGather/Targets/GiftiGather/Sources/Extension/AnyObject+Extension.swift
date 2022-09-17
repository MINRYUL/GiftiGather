//
//  AnyObject+Extension.swift
//  GiftiGather
//
//  Created by 김민창 on 2022/09/07.
//  Copyright © 2022 GiftiGather. All rights reserved.
//

import Foundation

extension NSObject {
  static var className: String {
    return String(describing: self)
  }
}
