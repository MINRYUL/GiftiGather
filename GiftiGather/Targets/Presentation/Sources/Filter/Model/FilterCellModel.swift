//
//  FilterCellModel.swift
//  GiftiGather
//
//  Created by 김민창 on 2023/02/11.
//  Copyright © 2023 GiftiGather. All rights reserved.
//

import Foundation

public struct FilterCellModel: CellModel {
  public var identity: UUID
  public var filter: String
  public var isCheck: Bool
}
