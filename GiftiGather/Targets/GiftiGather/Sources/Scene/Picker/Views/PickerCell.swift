//
//  PickerCell.swift
//  PresentationTests
//
//  Created by 김민창 on 2022/09/26.
//  Copyright © 2022 GiftiGather. All rights reserved.
//

import UIKit
import Presentation

import RxSwift

final class PickerCell: BaseCollectionViewCell {
  private lazy var _imageContainerView: UIView = {
    let view = UIView()
    view.layer.cornerRadius = 8
    view.clipsToBounds = true
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private lazy var _imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  private lazy var _checkImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(systemName: "checkmark.circle.fill")
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  private var _disposeBag: DisposeBag = DisposeBag()
  
  override func viewDidInit() {
    super.viewDidInit()
    
    self._configureUI()
  }
  
  func display(cellModel: PickCellModel) {
    self._imageView.setImage(with: cellModel.imageIdentifier, disposeBag: _disposeBag)
    
    switch cellModel.isCheck {
      case true:
        self._checkImageView.tintColor = .systemBlue
        self._imageContainerView.layer.borderWidth = 2
        self._imageContainerView.layer.borderColor = UIColor.systemBlue.cgColor
        
      case false:
        self._checkImageView.tintColor = .gray
        self._imageContainerView.layer.borderColor = UIColor.clear.cgColor
    }
  }
  
}

//MARK: - Configure UI
extension PickerCell {
  private func _configureUI() {
    self.contentView.addSubview(self._imageContainerView)
    self._imageContainerView.addSubview(self._imageView)
    self._imageContainerView.addSubview(self._checkImageView)
    
    NSLayoutConstraint.activate([
      self._imageContainerView.topAnchor.constraint(equalTo: self.topAnchor),
      self._imageContainerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      self._imageContainerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      self._imageContainerView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
    ])
    
    NSLayoutConstraint.activate([
      self._checkImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 3),
      self._checkImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -3),
      self._checkImageView.heightAnchor.constraint(equalToConstant: 30),
      self._checkImageView.widthAnchor.constraint(equalToConstant: 30)
    ])
    
    NSLayoutConstraint.activate([
      self._imageView.topAnchor.constraint(equalTo: self._imageContainerView.topAnchor),
      self._imageView.leadingAnchor.constraint(equalTo: self._imageContainerView.leadingAnchor),
      self._imageView.trailingAnchor.constraint(equalTo: self._imageContainerView.trailingAnchor),
      self._imageView.bottomAnchor.constraint(equalTo: self._imageContainerView.bottomAnchor)
    ])
  }
}
