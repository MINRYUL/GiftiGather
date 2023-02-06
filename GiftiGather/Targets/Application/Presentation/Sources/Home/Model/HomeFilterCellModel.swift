//
//  HomeFilterCellModel.swift
//  GiftiGather
//
//  Created by 김민창 on 2022/09/17.
//  Copyright © 2022 GiftiGather. All rights reserved.
//

import Foundation

public struct HomeFilterCellModel: CellModel {
  public var identity = UUID()
  public let title: String
  public let isAdd: Bool
}
