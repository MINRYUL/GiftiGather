//
//  DefaultDeleteFilter.swift
//  Domain
//
//  Created by 김민창 on 2023/02/11.
//  Copyright © 2023 GiftiGather. All rights reserved.
//

import Foundation

import Core
import DIContainer

public struct DefaultDeleteFilter: DeleteFilter {
  
  @Injected private var _repository: FilterRepository
  
  public init() { }
  
  public func deleteFilter(requestValue: String) -> Result<Void, DefaultError> {
    return _repository.deleteFilter(identity: requestValue)
  }
}
