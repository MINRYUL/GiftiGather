//
//  WriteGiftiCon.swift
//  GiftiGather
//
//  Created by 김민창 on 2022/10/15.
//  Copyright © 2022 GiftiGather. All rights reserved.
//

import Foundation

import Core
import DIContainer

public struct DefaultWriteGifticon: WriteGifticon {
  
  @Injected private var _repository: GifticonRepository
  
  public init() { }
  
  public func writeGifticon(requestValue: [GiftiInfoDTO]) -> Result<Void, DefaultError> {
    return _repository.insertGiftiList(
      giftiList: requestValue.map { gifti -> GiftiInfoDTO in
          return GiftiInfoDTO(
            identifier: gifti.identifier,
            giftiType: gifti.giftiType,
            giftiValidity: gifti.giftiValidity,
            filter: gifti.filter
          )
      }
    )
  }
}
