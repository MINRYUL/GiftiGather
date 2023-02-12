//
//  FilterViewController+Extension.swift
//  GiftiGather
//
//  Created by 김민창 on 2023/02/08.
//  Copyright © 2023 GiftiGather. All rights reserved.
//

import UIKit

extension FilterViewController {
  func configureUI() {
    self.title = "filter".localized()
    
    self.addButton.transform = addButton.transform.rotated(by: CGFloat(Double.pi) / 2)
    
    self.view.backgroundColor = .systemBackground
    self.view.addSubview(self.addContainerView)
    self.view.addSubview(self.collectionView)
    
    self.addContainerView.addSubview(self.titleLabel)
    self.addContainerView.addSubview(self.addButton)
    self.addContainerView.addSubview(self.addFooterView)
    
    self._configureAddView()
    self._configureCollectionView()
    
    self.collectionView.collectionViewLayout = self._configureCompositionalLayout()
  }
  
  private func _configureAddView() {
    NSLayoutConstraint.activate([
      self.addContainerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
      self.addContainerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
      self.addContainerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
    ])
    
    NSLayoutConstraint.activate([
      self.titleLabel.topAnchor.constraint(equalTo: self.addContainerView.topAnchor, constant: 15),
      self.titleLabel.leadingAnchor.constraint(equalTo: self.addContainerView.leadingAnchor, constant: 15),
      self.titleLabel.bottomAnchor.constraint(equalTo: self.addContainerView.bottomAnchor, constant: -15)
    ])
    
    NSLayoutConstraint.activate([
      self.addButton.trailingAnchor.constraint(equalTo: self.addContainerView.trailingAnchor, constant: -15),
      self.addButton.centerYAnchor.constraint(equalTo: self.titleLabel.centerYAnchor),
    ])
    
    NSLayoutConstraint.activate([
      self.addFooterView.bottomAnchor.constraint(equalTo: self.addContainerView.bottomAnchor),
      self.addFooterView.leadingAnchor.constraint(equalTo: self.addContainerView.leadingAnchor),
      self.addFooterView.trailingAnchor.constraint(equalTo: self.addContainerView.trailingAnchor),
      self.addFooterView.heightAnchor.constraint(equalToConstant: 1)
    ])
  }
  
  private func _configureCollectionView() {
    NSLayoutConstraint.activate([
      self.collectionView.topAnchor.constraint(equalTo: self.addContainerView.bottomAnchor),
      self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
      self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
      self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
    ])
  }
  
  private func _configureCompositionalLayout() -> UICollectionViewCompositionalLayout {
    return UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
      switch FilterSection.init(rawValue: sectionNumber) {
        case .filter:
          return FilterCell.makeCollectionLayoutSection()
          
        case .noData:
          return NoDataCollectionViewCell.makeCollectionLayoutSection()
          
        default: return nil
      }
    }
  }
}
