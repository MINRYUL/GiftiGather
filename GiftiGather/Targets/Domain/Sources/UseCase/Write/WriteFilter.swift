//
//  WriteFilter.swift
//  Presentation
//
//  Created by 김민창 on 2023/02/11.
//  Copyright © 2023 GiftiGather. All rights reserved.
//

import Foundation

import Core
import DIContainer

public protocol WriteFilter: UseCase {
  func writeFilter(requestValue: String) -> Result<Void, DefaultError>
}
