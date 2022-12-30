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
    self.view.addSubview(self.addView)
    self.addView.addSubview(self.addImage)
    self.addView.addSubview(self.loadingView)
    
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
    
    NSLayoutConstraint.activate([
      self.addView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
      self.addView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
      self.addView.heightAnchor.constraint(equalToConstant: 50),
      self.addView.widthAnchor.constraint(equalToConstant: 50)
    ])
    
    NSLayoutConstraint.activate([
      self.addImage.centerXAnchor.constraint(equalTo: self.addView.centerXAnchor),
      self.addImage.centerYAnchor.constraint(equalTo: self.addView.centerYAnchor),
      self.addImage.heightAnchor.constraint(equalToConstant: 25),
      self.addImage.widthAnchor.constraint(equalToConstant: 25)
    ])
    
    NSLayoutConstraint.activate([
      self.loadingView.centerXAnchor.constraint(equalTo: self.addView.centerXAnchor),
      self.loadingView.centerYAnchor.constraint(equalTo: self.addView.centerYAnchor)
    ])
  }
  
  private func _configureCompositionalLayout() -> UICollectionViewCompositionalLayout {
    return UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
      switch HomeSection.init(rawValue: sectionNumber) {
        case .filter:
          let item = NSCollectionLayoutItem(
            layoutSize: .init(
              widthDimension: .estimated(100),
              heightDimension: .absolute(35)
            )
          )
          
          let group = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(
              widthDimension: .estimated(100),
              heightDimension: .estimated(35)
            ), subitems: [item]
          )
          
          let section = NSCollectionLayoutSection(group: group)
          section.orthogonalScrollingBehavior = .continuous
          section.contentInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)
          return section
          
        case .photos:
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
          
        case .nodata:
          let item = NSCollectionLayoutItem(
            layoutSize: .init(
              widthDimension: .fractionalWidth(1),
              heightDimension: .fractionalWidth(1)
            )
          )
          item.contentInsets = .init(top: 3, leading: 3, bottom: 3, trailing: 3)
          
          let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
              widthDimension: .fractionalWidth(1),
              heightDimension: .fractionalWidth(1)
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
