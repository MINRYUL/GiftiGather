//
//  HomeViewController+Extension.swift
//  DomainTests
//
//  Created by 김민창 on 2022/09/17.
//  Copyright © 2022 GiftiGather. All rights reserved.
//

import UIKit

extension HomeViewController {
  func configureUI() {
    self.navigationController?.navigationBar.prefersLargeTitles = true
    self.title = "Home".localized()
    
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
      switch HomeSection.init(rawValue: sectionNumber) {
        case .filter:
          let item = NSCollectionLayoutItem(
            layoutSize: .init(
              widthDimension: .estimated(100),
              heightDimension: .absolute(40)
            )
          )
          item.contentInsets = .init(top: 5, leading: 5, bottom: 5, trailing: 5)
          
          let group = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(
              widthDimension: .estimated(100),
              heightDimension: .estimated(30)
            ), subitems: [item]
          )
          group.contentInsets = .init(top: 5, leading: 5, bottom: 5, trailing: 5)
          
          let section = NSCollectionLayoutSection(group: group)
          section.orthogonalScrollingBehavior = .continuous
          section.contentInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)
          return section
          
        case .photos:
          let item = NSCollectionLayoutItem(
            layoutSize: .init(
              widthDimension: .fractionalWidth(1/3),
              heightDimension: .fractionalHeight(1.0)
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
