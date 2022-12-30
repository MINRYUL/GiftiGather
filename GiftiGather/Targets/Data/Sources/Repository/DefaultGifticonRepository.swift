//
//  DefaultGifticonRepository.swift
//  GiftiGather
//
//  Created by 김민창 on 2022/10/15.
//  Copyright © 2022 GiftiGather. All rights reserved.
//

import Foundation

import Core
import Domain

public struct DefaultGifticonRepository: GiftiConRepository {
  
  public func writeGifticon(gifticonList: [GiftiInfoDTO]) -> Result<Void, DefaultError> {
    return .success(())
  }
  
  public func deleteGifticon() -> Result<Void, DefaultError> {
    return .success(())
  }
}
