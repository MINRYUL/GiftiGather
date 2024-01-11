//
//  PickerViewController+Extension.swift
//  PresentationTests
//
//  Created by 김민창 on 2022/09/26.
//  Copyright © 2022 GiftiGather. All rights reserved.
//

import UIKit

extension PickerViewController {
  func configureUI() {
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
      self.addButton.centerYAnchor.constraint(equalTo: self.titleLabel.centerYAnchor)
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
      switch PickerSection.init(rawValue: sectionNumber) {
        case .pick:
          let item = NSCollectionLayoutItem(
            layoutSize: .init(
              widthDimension: .fractionalWidth(1/3),
              heightDimension: .fractionalWidth(1/3)
            )
          )
          item.contentInsets = .init(top: 3, leading: 3, bottom: 3, trailing: 3)
          
          let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
              widthDimension: .fractionalWidth(1.0),
              heightDimension: .fractionalWidth(1/3)
            ),
            subitems: [item]
          )
          
          let section = NSCollectionLayoutSection(group: group)
          section.orthogonalScrollingBehavior = .none
          section.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
          
          return section
        
        case .noData:
          return NoDataCollectionViewCell.makeCollectionLayoutSection()
          
        default: return nil
      }
    }
  }
}

