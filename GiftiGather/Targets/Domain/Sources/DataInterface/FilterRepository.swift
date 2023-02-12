//
//  FilterRepository.swift
//  GiftiGather
//
//  Created by 김민창 on 2023/02/11.
//  Copyright © 2023 GiftiGather. All rights reserved.
//

import Foundation

import Core

public protocol FilterRepository: Repository {
  func insertFilter(filter: String) -> Result<Void, DefaultError>
  func deleteFilter(identity: String) -> Result<Void, DefaultError>
  func fetchFilter() -> Result<[String], DefaultError>
}
