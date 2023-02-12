//
//  FetchFilter.swift
//  Presentation
//
//  Created by 김민창 on 2023/02/11.
//  Copyright © 2023 GiftiGather. All rights reserved.
//

import Foundation

import Core

public protocol FetchFilter: UseCase {
  func fetchFilter() -> Result<[String], DefaultError>
}
