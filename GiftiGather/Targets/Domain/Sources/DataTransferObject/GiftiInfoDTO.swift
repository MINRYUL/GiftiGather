//
//  GiftiInfoDTO.swift
//  GiftiGather
//
//  Created by 김민창 on 2022/10/15.
//  Copyright © 2022 GiftiGather. All rights reserved.
//

import Foundation

public struct GiftiInfoDTO: DataTransferObject {
  public let identifier: String
  public let giftiType: String
  public let giftiValidity: String //yyyy.MM.dd
  public let filter: String?
  
  public init(
    identifier: String,
    giftiType: String = "none",
    giftiValidity: String = "9999.12.31",
    filter: String? = nil
  ) {
    self.identifier = identifier
    self.giftiType = giftiType
    self.giftiValidity = giftiValidity
    self.filter = filter
  }
}
