//
//  DefaultFetchGifticon.swift
//  GiftiGather
//
//  Created by 김민창 on 2023/02/03.
//  Copyright © 2023 GiftiGather. All rights reserved.
//

import Foundation

import Core
import DIContainer

public struct DefaultFetchGifticon: FetchGifticon {
  
  @Injected private var _repository: GifticonRepository
  
  public init() { }
  
  public func fetchGifticon() -> Result<[GiftiInfoDTO], DefaultError> {
    return _repository.fetchGiftiList()
  }
}
