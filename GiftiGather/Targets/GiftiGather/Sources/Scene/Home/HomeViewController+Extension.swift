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
    self.view.addSubview(self.filterCollectionView)
    self.view.addSubview(self.collectionView)
    self.view.addSubview(self.addView)
    self.addView.addSubview(self.addImage)
    self.addView.addSubview(self.loadingView)
    
    self._configureCollectionView()
    self.filterCollectionView.collectionViewLayout = self._configureFilterCOmpositionalLayout()
    self.collectionView.collectionViewLayout = self._configureCompositionalLayout()
  }
  
  private func _configureCollectionView() {
    
    NSLayoutConstraint.activate([
      self.filterCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
      self.filterCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
      self.filterCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
      self.filterCollectionView.heightAnchor.constraint(equalToConstant: 60)
    ])
    
    NSLayoutConstraint.activate([
      self.collectionView.topAnchor.constraint(equalTo: self.filterCollectionView.bottomAnchor),
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
        case .photos:
          return HomePhotoCell.makeCollectionLayoutSection()
          
        case .nodata:
          return NoDataCollectionViewCell.makeCollectionLayoutSection()
          
        default: return nil
      }
    }
  }
  
  private func _configureFilterCOmpositionalLayout() -> UICollectionViewCompositionalLayout {
    return UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
      switch HomeFilterSection.init(rawValue: sectionNumber) {
        case .filter:
          return HomeFilterCell.makeCollectionLayoutSection()
          
        default: return nil
      }
    }
  }

}
