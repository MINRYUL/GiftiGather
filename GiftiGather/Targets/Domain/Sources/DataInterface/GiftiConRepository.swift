//
//  GiftiConRepository.swift
//  GiftiGather
//
//  Created by 김민창 on 2022/10/15.
//  Copyright © 2022 GiftiGather. All rights reserved.
//

import Foundation

import Core

public protocol GifticonRepository {
  func insertGiftiList(giftiList: [GiftiInfoDTO]) -> Bool
  func deleteGifti(identity: String) -> Bool
  func fetchGiftiList() -> [GiftiInfoDTO]
}
