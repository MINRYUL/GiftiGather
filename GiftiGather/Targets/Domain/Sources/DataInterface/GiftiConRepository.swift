//
//  GiftiConRepository.swift
//  GiftiGather
//
//  Created by 김민창 on 2022/10/15.
//  Copyright © 2022 GiftiGather. All rights reserved.
//

import Foundation

import Core

import RxSwift

public protocol GiftiConRepository {
  func writeGifticon(gifticonList: [GiftiInfoDTO]) -> Observable<Result<Void, DefaultError>>
}
