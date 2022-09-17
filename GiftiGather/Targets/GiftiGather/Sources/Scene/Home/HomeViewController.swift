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
  case filter, photos, nodata
}

final class HomeViewController: BaseViewController {
  //MARK: - Typealias
  typealias HomeDataSource = UICollectionViewDiffableDataSource<HomeSection, AnyHashable>
  typealias SourceSnapshot = NSDiffableDataSourceSnapshot<HomeSection, AnyHashable>
  
  //MARK: - View
  lazy var collectionView: UICollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    let collectionView = UICollectionView(frame: .init(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: flowLayout)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    return collectionView
  }()
  
  private var _dataSource: HomeDataSource?
  
  //MARK: - Injection
  @Injected private var _viewModel: HomeViewModel
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.configureUI()
    
    self._configureRegister()
    self._configureDataSource()
    self._configureData()
    
    self._bindFilterDataSource()
    self._bindPhotoDataSource()
    self._bindNoDataSource()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(true)
    
    self.showToast("토스트를 보여주자")
  }
  
  //MARK: - Configure
  private func _configureRegister() {
    HomeFilterCell.register(to: self.collectionView)
    HomePhotoCell.register(to: self.collectionView)
    NoDataCollectionViewCell.register(to: self.collectionView)
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
            ) as? HomeFilterCell,
                  let item = item as? HomeFilterCellModel
            else  { return UICollectionViewCell() }
            
            cell.display(cellModel: item)
            
            return cell
            
          case .photos:
            guard let cell = collectionView.dequeueReusableCell(
              withReuseIdentifier: HomePhotoCell.identifier,
              for: indexPath
            ) as? HomePhotoCell,
                  let item = item as? HomePhotoCellModel
            else  { return UICollectionViewCell() }
            
            cell.display(cellModel: item)
            
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
  private func _bindFilterDataSource() {
    self._viewModel.output.filterDataSource
      .drive(onNext: { dataSource in
        self._sectionSnapShotApply(section: .filter, item: dataSource)
      })
      .disposed(by: disposeBag)
  }
  
  private func _bindPhotoDataSource() {
    self._viewModel.output.photoDataSource
      .drive(onNext: { dataSource in
        self._sectionSnapShotApply(section: .photos, item: dataSource)
      })
      .disposed(by: disposeBag)
  }
  
  private func _bindNoDataSource() {
    self._viewModel.output.noDataSource
      .drive(onNext: { dataSource in
        self._sectionSnapShotApply(section: .nodata, item: dataSource)
      })
      .disposed(by: disposeBag)
  }
}

//MARK: - Apply
extension HomeViewController {
  private func _sectionSnapShotApply(section: HomeSection, item: [AnyHashable]) {
    DispatchQueue.global().sync {
      guard var snapshot = self._dataSource?.snapshot() else { return }
      item.forEach {
        snapshot.appendItems([$0], toSection: section)
      }
      self._dataSource?.apply(snapshot, animatingDifferences: true)
    }
  }
}
