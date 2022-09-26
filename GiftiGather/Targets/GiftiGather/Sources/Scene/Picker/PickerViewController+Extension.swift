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
    
    self.view.addSubview(self.collectionView)
    
    self._configureCollectionView()
    
    self.collectionView.collectionViewLayout = self._configureCompositionalLayout()
  }
  
  private func _configureCollectionView() {
    NSLayoutConstraint.activate([
      self.collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
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
          
        default: return nil
      }
    }
  }
}

