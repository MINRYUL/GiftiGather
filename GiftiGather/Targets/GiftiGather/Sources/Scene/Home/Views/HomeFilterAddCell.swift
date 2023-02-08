//
//  HomeFilterAddCell.swift
//  GiftiGather
//
//  Created by 김민창 on 2023/02/06.
//  Copyright © 2023 GiftiGather. All rights reserved.
//

import Presentation
import UIKit
import Photos

import RxSwift

protocol HomeFilterAddCellDelegate: AnyObject {
  func didTouchAdd()
}

final class HomeFilterAddCell: BaseCollectionViewCell {
  lazy private var _containerView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .background
    view.layer.cornerRadius = 5
    view.layer.borderColor = UIColor.systemGray.cgColor
    view.layer.borderWidth = 1
    view.clipsToBounds = true
    return view
  }()
  
  lazy private var _imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = UIImage(systemName: "plus")
    imageView.tintColor = .label
    return imageView
  }()
  
  lazy private var _trailingFooterView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .systemGray3
    return view
  }()
  
  weak var delegate: HomeFilterAddCellDelegate?
  
  private var _disposeBag: DisposeBag = DisposeBag()
  
  override func viewDidInit() {
    super.viewDidInit()
    
    self._configureUI()
    self._configureGestrue()
  }
  
  @objc func addAction() {
    self.delegate?.didTouchAdd()
  }
}

extension HomeFilterAddCell {
  private func _configureUI() {
    self.contentView.addSubview(_containerView)
    self.contentView.addSubview(_trailingFooterView)
    
    self._containerView.addSubview(_imageView)
    
    NSLayoutConstraint.activate([
      self._containerView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 2),
      self._containerView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 3),
      self._containerView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -2),
      self._containerView.widthAnchor.constraint(equalToConstant: 40)
    ])
    
    NSLayoutConstraint.activate([
      self._imageView.centerXAnchor.constraint(equalTo: self._containerView.centerXAnchor),
      self._imageView.centerYAnchor.constraint(equalTo: self._containerView.centerYAnchor)
    ])
    
    NSLayoutConstraint.activate([
      self._trailingFooterView.leadingAnchor.constraint(equalTo: self._containerView.trailingAnchor, constant: 10),
      self._trailingFooterView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
      self._trailingFooterView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
      self._trailingFooterView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5),
      self._trailingFooterView.widthAnchor.constraint(equalToConstant: 1)
    ])
  }
  
  private func _configureGestrue() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addAction))
    self._containerView.addGestureRecognizer(tapGesture)
  }
}
