//
//  DetailGiftiViewController+Extension.swift
//  GiftiGather
//
//  Created by 김민창 on 2023/03/01.
//  Copyright © 2023 GiftiGather. All rights reserved.
//

import UIKit

extension DetailGiftiViewController {
  func configureUI() {
    self.view.addSubview(self.detailScrollView)
    self.view.backgroundColor = .black.withAlphaComponent(0.6)
    
    self.detailScrollView.addSubview(self.contentView)
    
    self.contentView.addSubview(self.headerImageView)
    self.contentView.addSubview(self.dismissButton)
    
    self.contentView.addSubview(self.dummyView)
    
    self._configureLayout()
  }
  
  private func _configureLayout() {
    let imageWidth = UIScreen.main.bounds.width
    
    NSLayoutConstraint.activate([
      self.detailScrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
      self.detailScrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
      self.detailScrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
      self.detailScrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
    ])
    
    NSLayoutConstraint.activate([
      self.contentView.topAnchor.constraint(equalTo: self.detailScrollView.topAnchor),
      self.contentView.leadingAnchor.constraint(equalTo: self.detailScrollView.leadingAnchor),
      self.contentView.trailingAnchor.constraint(equalTo: self.detailScrollView.trailingAnchor),
      self.contentView.bottomAnchor.constraint(equalTo: self.detailScrollView.bottomAnchor),
      self.contentView.widthAnchor.constraint(equalTo: self.detailScrollView.widthAnchor),
    ])
    
    NSLayoutConstraint.activate([
      self.headerImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
      self.headerImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
      self.headerImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
      self.headerImageView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor),
      self.headerImageView.heightAnchor.constraint(equalToConstant: imageWidth),
    ])
    
    NSLayoutConstraint.activate([
      self.dismissButton.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 15),
      self.dismissButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -15),
      self.dismissButton.widthAnchor.constraint(equalToConstant: 50),
      self.dismissButton.heightAnchor.constraint(equalToConstant: 50)
    ])
    
    NSLayoutConstraint.activate([
      self.dummyView.topAnchor.constraint(equalTo: self.headerImageView.bottomAnchor),
      self.dummyView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
      self.dummyView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
      self.dummyView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
      self.dummyView.heightAnchor.constraint(equalToConstant: 1000),
    ])
  }
}
