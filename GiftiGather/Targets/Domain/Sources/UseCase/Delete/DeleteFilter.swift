//
//  DeleteFilter.swift
//  Domain
//
//  Created by 김민창 on 2023/02/11.
//  Copyright © 2023 GiftiGather. All rights reserved.
//

import Foundation

import Core

public protocol DeleteFilter: UseCase {
  func deleteFilter(requestValue: String) -> Result<Void, DefaultError>
}
