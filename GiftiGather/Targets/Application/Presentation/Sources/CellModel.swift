//
//  CellModel.swift
//  GiftiGather
//
//  Created by 김민창 on 2022/09/17.
//  Copyright © 2022 GiftiGather. All rights reserved.
//

import Foundation

public protocol CellModel: Hashable {
  var identity: UUID { get set }
}

public extension CellModel {
  func hash(into hasher: inout Hasher) {
    hasher.combine(identity)
  }

  static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.identity == rhs.identity
  }
}
