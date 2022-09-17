//
//  PhotoManager.swift
//  DomainTests
//
//  Created by 김민창 on 2022/09/17.
//  Copyright © 2022 GiftiGather. All rights reserved.
//

import Foundation
import Photos

import RxSwift
import RxCocoa

final class PhotosManager {
  private let _imagesArray = PHAsset.fetchAssets(with: .image, options: nil)

  //MARK: - Output
  let imageFetchProgress: Driver<Float?>
  private var _imageFetchProgress = PublishSubject<Float?>()
  
  private init() {
    self.imageFetchProgress = self._imageFetchProgress.asDriver(onErrorJustReturn: nil)
  }
  
  
  func startFetchGifticon() {
    
  }
}
