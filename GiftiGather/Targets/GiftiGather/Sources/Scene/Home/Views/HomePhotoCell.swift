//
//  HomePhotosCell.swift
//  GiftiGather
//
//  Created by 김민창 on 2022/09/17.
//  Copyright © 2022 GiftiGather. All rights reserved.
//

import Presentation
import UIKit
import Photos

import RxSwift

final class HomePhotoCell: BaseCollectionViewCell {
  private var _imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFill
    imageView.layer.cornerRadius = 10
    imageView.clipsToBounds = true
    imageView.backgroundColor = .systemGray2
    return imageView
  }()
  
  private var _disposeBag = DisposeBag()
  
  private var _photoIdentifier: String?
  
  override func viewDidInit() {
    super.viewDidInit()
    
    self._configureUI()
  }
  
  func display(cellModel: HomePhotoCellModel) {
    self._photoIdentifier = cellModel.photoLocalIentifier
    PhotosManager.fetchImageWithIdentifier(
      cellModel.photoLocalIentifier,
      targetSize: PHImageManagerMaximumSize
    ).asDriver(onErrorJustReturn: (nil, cellModel.photoLocalIentifier))
      .map { [weak self] (image, identifier) -> UIImage? in
        switch identifier == self?._photoIdentifier {
          case true: return image
          case false: return nil
        }
      }
      .compactMap { $0 }
      .drive(self._imageView.rx.image)
      .disposed(by: self._disposeBag)
    
  }
}

extension HomePhotoCell {
  private func _configureUI() {
    self.contentView.addSubview(_imageView)
    
    NSLayoutConstraint.activate([
      self._imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
      self._imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
      self._imageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
      self._imageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
    ])
  }
}
