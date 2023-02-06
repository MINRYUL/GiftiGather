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

import Photos

import RxSwift
import RxCocoa

enum HomeSection: Int, CaseIterable {
  case photos, nodata
}

enum HomeFilterSection: Int, CaseIterable {
  case filter
}

final class HomeViewController: BaseViewController {
  //MARK: - Typealias
  typealias HomeDataSource = UICollectionViewDiffableDataSource<HomeSection, AnyHashable>
  typealias SourceSnapshot = NSDiffableDataSourceSnapshot<HomeSection, AnyHashable>
  
  typealias HomeFilterDataSource = UICollectionViewDiffableDataSource<HomeFilterSection, AnyHashable>
  typealias FilterSourceSnapshot = NSDiffableDataSourceSnapshot<HomeFilterSection, AnyHashable>
  
  //MARK: - View
  lazy var collectionView: UICollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    let collectionView = UICollectionView(frame: .init(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: flowLayout)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
    return collectionView
  }()
  
  lazy var filterCollectionView: UICollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    let collectionView = UICollectionView(frame: .init(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: flowLayout)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    return collectionView
  }()
  
  lazy var addView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .systemBlue
    view.layer.cornerRadius = 25
    view.clipsToBounds = true
    return view
  }()
  
  lazy var addImage: UIView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = UIImage(systemName: "plus")
    imageView.tintColor = .white
    return imageView
  }()
  
  lazy var loadingView: UIActivityIndicatorView = {
    let loadingView = UIActivityIndicatorView(style: .medium)
    loadingView.translatesAutoresizingMaskIntoConstraints = false
    loadingView.color = .white
    loadingView.isHidden = true
    return loadingView
  }()
  
  private var _dataSource: HomeDataSource?
  private var _filterDataSource: HomeFilterDataSource?
  
  private var _status: HomeViewStatus = .none {
    didSet {
      switch self._status {
        case .none:
          self.loadingView.stopAnimating()
          self.addImage.isHidden = false
        case .progress:
          self.loadingView.startAnimating()
          self.addImage.isHidden = true
      }
    }
  }
  
  //MARK: - Injection
  @Injected private var _viewModel: HomeViewModel
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.configureUI()
    self._configureFilterCollectionView()
    self._configureDataSource()
    self._configureData()
    self._configureGesture()
    
    self._bindFilterDataSource()
    self._bindPhotoDataSource()
    self._bindNoDataSource()
    
    self._bindGifticonFetchProgress()
    
    self._viewModel.input.getGiftiCon.onNext(())
  }
  
  //MARK: - Action
  @objc private func _addImageAction() {
    switch self._status {
      case .none:
        let alert = UIAlertController(
          title: nil,
          message: nil,
          preferredStyle: UIAlertController.Style.actionSheet
        )
        let autoAction =  UIAlertAction(
          title: "gifticon_auto_add".localized(),
          style: UIAlertAction.Style.default,
          handler: { [weak self] _ in
            self?._status = .progress
            self?._fetchGifticon()
          }
        )
        let directAction =  UIAlertAction(
          title: "gifticon_directly_add".localized(),
          style: UIAlertAction.Style.default,
          handler: { [weak self] _ in
            self?._fetchAllIdentifier()
          }
        )
        
        let cancelAction = UIAlertAction(
          title: "cancel".localized(), style: UIAlertAction.Style.cancel
        )
        
        alert.addAction(autoAction)
        alert.addAction(directAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: false)
        
      case .progress: break
    }
  }
  
  //MARK: - Configure
  private func _configureDataSource() {
    let photoRegistration = UICollectionView.CellRegistration<HomePhotoCell, HomePhotoCellModel> {
      (cell, indexPath, cellModel) in
      cell.display(cellModel: cellModel)
    }
    
    let noDataRegistration = UICollectionView.CellRegistration<NoDataCollectionViewCell, NoDataCellModel> {
      (cell, indexPath, cellModel) in
      cell.display(cellModel: cellModel)
    }
    
      let dataSource = HomeDataSource (
        collectionView: collectionView,
        cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell in
        
        switch HomeSection.init(rawValue: indexPath.section) {
          case .photos:
            return collectionView.dequeueConfiguredReusableCell(
              using: photoRegistration, for: indexPath, item: item as? HomePhotoCellModel
            )
            
          case .nodata:
            return collectionView.dequeueConfiguredReusableCell(
              using: noDataRegistration, for: indexPath, item: item as? NoDataCellModel
            )
            
          default: return UICollectionViewCell()
        }
      })
      
      self._dataSource = dataSource
      collectionView.dataSource = dataSource
  }
  
  private func _configureFilterCollectionView() {
    let filterRegistration = UICollectionView.CellRegistration<HomeFilterCell, HomeFilterCellModel> {
      (cell, indexPath, cellModel) in
      cell.display(cellModel: cellModel)
    }
    
    let addRegistration = UICollectionView.CellRegistration<HomeFilterAddCell, String> {
      [weak self] (cell, _, _)  in
      cell.delegate = self
    }
    
    let dataSource = HomeFilterDataSource (
      collectionView: filterCollectionView,
      cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell in
        
        switch HomeFilterSection.init(rawValue: indexPath.section) {
          case .filter:
            guard let item = item as? HomeFilterCellModel else { return UICollectionViewCell() }
            
            switch item.isAdd {
              case true:
                return collectionView.dequeueConfiguredReusableCell(
                  using: addRegistration, for: indexPath, item: item.identity.uuidString
                )
                
              case false:
                return collectionView.dequeueConfiguredReusableCell(
                  using: filterRegistration, for: indexPath, item: item
                )
            }
            
          default: return UICollectionViewCell()
        }
      })
      
      self._filterDataSource = dataSource
      filterCollectionView.dataSource = dataSource
  }
  
  private func _configureData() {
    var filterSnapshot = FilterSourceSnapshot()
    HomeFilterSection.allCases.forEach {
      filterSnapshot.appendSections([$0])
    }
    self._filterDataSource?.apply(filterSnapshot, animatingDifferences: true)
    
    var snapshot = SourceSnapshot()
    HomeSection.allCases.forEach {
      snapshot.appendSections([$0])
    }
    self._dataSource?.apply(snapshot, animatingDifferences: true)
  }
  
  private func _configureGesture() {
    let addGesture = UITapGestureRecognizer(target: self, action: #selector(_addImageAction))
    self.addView.addGestureRecognizer(addGesture)
  }
}

//MARK: - Output Binding
extension HomeViewController {
  private func _bindFilterDataSource() {
    self._viewModel.output.filterDataSource
      .drive(onNext: { [weak self] dataSource in
        self?._sectionSnapShotApply(section: .filter, item: dataSource)
      })
      .disposed(by: disposeBag)
  }
  
  private func _bindPhotoDataSource() {
    self._viewModel.output.photoDataSource
      .drive(onNext: { [weak self] dataSource in
        self?._sectionSnapShotApply(section: .photos, item: dataSource)
      })
      .disposed(by: disposeBag)
  }
  
  private func _bindNoDataSource() {
    self._viewModel.output.noDataSource
      .drive(onNext: { [weak self] dataSource in
        self?._sectionSnapShotApply(section: .nodata, item: dataSource)
      })
      .disposed(by: disposeBag)
  }
  
  private func _bindGifticonFetchProgress() {
    PhotosManager.shared.gifticonFetchProgress
      .compactMap { $0 }
      .drive(onNext: { progress in
        print(progress)
      })
      .disposed(by: disposeBag)
  }
  
  private func _fetchGifticon() {
    PhotosManager.shared.fetchGifticon()
      .asDriver(onErrorJustReturn: [])
      .drive(onNext: { [weak self] imageIdentifiers in
        self?._presentToPickerViewController(
          imageIdentifier: imageIdentifiers, isAllSelect: true
        )
      })
      .disposed(by: disposeBag)
  }
  
  private func _fetchAllIdentifier() {
    PhotosManager.shared.fetchAllIdentifier()
      .asDriver(onErrorJustReturn: [])
      .drive(onNext: { [weak self] imageIdentifiers in
        self?._presentToPickerViewController(
          imageIdentifier: imageIdentifiers, isAllSelect: false
        )
      })
      .disposed(by: disposeBag)
  }
  
  private func _presentToPickerViewController(
    imageIdentifier: [String], isAllSelect: Bool
  ) {
    guard let pickerViewController = PickerViewController
      .instantiate() as? PickerViewController else { return }
    
    pickerViewController.delegate = self
    pickerViewController.imageIdentifierListWithCheck = (imageIdentifier, isAllSelect)
    
    self._status = .none
    self.present(pickerViewController, animated: true)
  }
}

//MARK: - Apply
extension HomeViewController {
  private func _sectionSnapShotApply(section: HomeSection, item: [AnyHashable]) {
    guard var snapshot = self._dataSource?.snapshot() else { return }
    item.forEach {
      snapshot.appendItems([$0], toSection: section)
    }
    self._dataSource?.apply(snapshot, animatingDifferences: true)
  }
  
  private func _sectionSnapShotApply(section: HomeFilterSection, item: [AnyHashable]) {
    guard var snapshot = self._filterDataSource?.snapshot() else { return }
    item.forEach {
      snapshot.appendItems([$0], toSection: section)
    }
    self._filterDataSource?.apply(snapshot, animatingDifferences: true)
  }
  
  private func _deleteSection(section: HomeSection) {
    guard var snapshot = self._dataSource?.snapshot() else { return }
    snapshot.deleteSections([section])
    self._dataSource?.apply(snapshot, animatingDifferences: false)
  }
}

//MARK: - PickerViewControllerDelegate
extension HomeViewController: PickerViewControllerDelegate {
  func didSelectImageIdentifiers(
    _ viewController: PickerViewController, imageIdentifiers: [String]
  ) {
    self._viewModel.input.selectedImageIdentifers.onNext(imageIdentifiers)
  }
}

//MARK: - HomeFilterAddCellDelegate
extension HomeViewController: HomeFilterAddCellDelegate {
  func didTouchAdd() {
    
  }
}
