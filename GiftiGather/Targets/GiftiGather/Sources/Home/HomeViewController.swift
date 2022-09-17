//
//  HomeViewController.swift
//  GiftiGather
//
//  Created by 김민창 on 2022/09/07.
//  Copyright © 2022 GiftiGather. All rights reserved.
//

import UIKit
import DIContainer
import Presentation

import RxSwift
import RxCocoa

enum HomeSection: Int, CaseIterable {
    case filter, photos
}

final class HomeViewController: BaseViewController {
  
  typealias HomeDataSource = UICollectionViewDiffableDataSource<HomeSection, AnyHashable>
  typealias SourceSnapshot = NSDiffableDataSourceSnapshot<HomeSection, AnyHashable>
  
  lazy var collectionView: UICollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    let collectionView = UICollectionView(frame: .init(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: flowLayout)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    return collectionView
  }()
  
  private var _dataSource: HomeDataSource?
  
  @Injected private var _viewModel: HomeViewModel
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.configureUI()
    
    self._configureRegister()
    self._configureData()
    
    self._configureDataSource()
  }
  
  //MARK: - Configure
  private func _configureRegister() {
    HomeFilterCell.register(to: self.collectionView)
    HomePhotoCell.register(to: self.collectionView)
  }
  
  private func _configureData() {
      var snapshot = SourceSnapshot()
      HomeSection.allCases.forEach {
          snapshot.appendSections([$0])
      }
    self._dataSource?.apply(snapshot, animatingDifferences: true)
  }
  
  private func _configureDataSource() {
      let dataSource = HomeDataSource (collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell in
        
        switch HomeSection.init(rawValue: indexPath.section) {
          case .filter:
            guard let cell = collectionView.dequeueReusableCell(
              withReuseIdentifier: HomeFilterCell.identifier,
              for: indexPath
            ) as? HomeFilterCell else  { return UICollectionViewCell() }
            
            return cell
            
          case .photos:
            guard let cell = collectionView.dequeueReusableCell(
              withReuseIdentifier: HomePhotoCell.identifier,
              for: indexPath
            ) as? HomePhotoCell else { return UICollectionViewCell() }
            
            return cell
            
          default: return UICollectionViewCell()
            
        }
      })
      
      self._dataSource = dataSource
      collectionView.dataSource = dataSource
  }
}

//MARK: - Output Binding
extension HomeViewController {
}
