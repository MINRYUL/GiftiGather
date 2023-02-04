//
//  FetchGifticon.swift
//  GiftiGather
//
//  Created by 김민창 on 2023/02/03.
//  Copyright © 2023 GiftiGather. All rights reserved.
//

import Foundation

import Core

public protocol FetchGifticon: UseCase {
  func fetchGifticon() -> Result<[GiftiInfoDTO], DefaultError>
}
