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
  
  private var _disposeBag: DisposeBag = DisposeBag()
  
  override func viewDidInit() {
    super.viewDidInit()
    
    self._configureUI()
  }
  
  func display(cellModel: HomePhotoCellModel?) {
    guard let cellModel = cellModel else { return }
    self._imageView.setImage(with: cellModel.photoLocalIentifier, disposeBag: _disposeBag)
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

//MARK: - UI
extension HomePhotoCell {
  static func makeCollectionLayoutSection() -> NSCollectionLayoutSection {
    let item = NSCollectionLayoutItem(
      layoutSize: .init(
        widthDimension: .fractionalWidth(0.5),
        heightDimension: .fractionalWidth(0.5)
      )
    )
    item.contentInsets = .init(top: 3, leading: 3, bottom: 3, trailing: 3)
    
    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: .init(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .fractionalWidth(0.5)
      ),
      subitems: [item]
    )
    
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .none
    section.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
    
    return section
  }
}
