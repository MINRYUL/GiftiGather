//
//  HomePhotoCell.swift
//  PresentationTests
//
//  Created by 김민창 on 2022/09/26.
//  Copyright © 2022 GiftiGather. All rights reserved.
//

import UIKit
import Photos

import RxSwift
import RxCocoa

extension UIImageView {
  func setImage(with localIdentifier: String, disposeBag: DisposeBag) {
    self.accessibilityIdentifier = localIdentifier
    
    PhotosManager.fetchImageWithIdentifier(
      localIdentifier,
      targetSize: PHImageManagerMaximumSize
    ).asDriver(onErrorJustReturn: (nil, localIdentifier))
      .map { [weak self] (image, identifier) -> UIImage? in
        switch identifier == self?.accessibilityIdentifier {
          case true: return image
          case false: return nil
        }
      }
      .compactMap { $0 }
      .drive(self.rx.image)
      .disposed(by: disposeBag)
  }
}
