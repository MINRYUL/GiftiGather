//
//  GiftiConRepository.swift
//  GiftiGather
//
//  Created by 김민창 on 2022/10/15.
//  Copyright © 2022 GiftiGather. All rights reserved.
//

import Foundation

import Core

public protocol GifticonRepository: Repository {
  func insertGiftiList(giftiList: [GiftiInfoDTO]) -> Result<Void, DefaultError>
  func deleteGifti(identity: String) -> Result<Void, DefaultError>
  func fetchGiftiList() -> Result<[GiftiInfoDTO], DefaultError>
}
