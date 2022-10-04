//
//  PickCellModel.swift
//  PresentationTests
//
//  Created by 김민창 on 2022/09/26.
//  Copyright © 2022 GiftiGather. All rights reserved.
//

import Foundation

public struct PickCellModel: CellModel, Equatable {
  public var identity = UUID()
  public let isCheck: Bool
  public let imageIdentifier: String
}
