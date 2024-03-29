//
//  HomeViewController.swift
//  GiftiGather
//
//  Created by 김민창 on 2022/09/07.
//  Copyright © 2022 GiftiGather. All rights reserved.
//

import UIKit
import Photos

import DIContainer
import Presentation

import RxSwift
import RxCocoa

enum HomeSection: Int, CaseIterable {
  case photos, nodata
}

enum HomeFilterSection: Int, CaseIterable {
  case filter
}

final class HomeViewController: BaseViewController, SourceTransitionViewController {
  //MARK: - Typealias
  typealias HomeDataSource = UICollectionViewDiffableDataSource<HomeSection, UUID>
  typealias HomeFilterDataSource = UICollectionViewDiffableDataSource<HomeFilterSection, UUID>
  
  var fromView: UIView {
    guard let cell = self.collectionView.cellForItem(at: self._selectedIndexPath) else {
      return UIView()
    }
    
    return cell
  }
  
  //MARK: - View
  lazy var collectionView: UICollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    let collectionView = UICollectionView(frame: .init(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: flowLayout)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
    collectionView.delaysContentTouches = false
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
  
  private var _filterDataSourceManager: DataSourceSnapshotManager<HomeFilterSection>?
  private var _photoDataSourceManager: DataSourceSnapshotManager<HomeSection>?
  private var _filterDataSourceMap = [UUID: HomeFilterCellModel]()
  private var _photoDataSourceMap = [UUID: HomePhotoCellModel]()
  private var _noDataSourceMap = [UUID: NoDataCellModel]()
  
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
  
  private var _selectedIndexPath: IndexPath = IndexPath()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.configureUI()
    self._configureFilterCollectionView()
    self._configureDataSource()
    self._configureData()
    self._configureGesture()
    
    self._bindFilterDataSource()
    self._bindPhotoDataSource()
    self._bindConfirmSelect()
    self._bindNoDataSource()
    self._bindDidDeleteNoData()
    
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
    let photoRegistration = UICollectionView.CellRegistration<HomePhotoCell, UUID> {
      [weak self] (cell, indexPath, id) in
      cell.display(cellModel: self?._photoDataSourceMap[id])
    }
    
    let noDataRegistration = UICollectionView.CellRegistration<NoDataCollectionViewCell, UUID> {
      [weak self] (cell, indexPath, id) in
      cell.display(cellModel: self?._noDataSourceMap[id])
    }
    
    let dataSource = HomeDataSource (
      collectionView: collectionView,
      cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell in
        
        switch HomeSection.init(rawValue: indexPath.section) {
          case .photos:
            return collectionView.dequeueConfiguredReusableCell(
              using: photoRegistration, for: indexPath, item: item
            )
            
          case .nodata:
            return collectionView.dequeueConfiguredReusableCell(
              using: noDataRegistration, for: indexPath, item: item
            )
            
          default: return UICollectionViewCell()
        }
      })
    
    self._photoDataSourceManager = DataSourceSnapshotManager(dataSource: dataSource)
    collectionView.dataSource = dataSource
    
    collectionView.delegate = self
    
    collectionView.rx.itemSelected
      .asDriver()
      .drive(onNext: { [weak self] indexPath in
        guard let self = self else { return }
        self._viewModel.input.selectedGifti.onNext(indexPath)
      })
      .disposed(by: disposeBag)
    
    collectionView.rx.itemHighlighted
      .asDriver()
      .drive(onNext: { [weak self] indexPath in
        guard let collectionView = self?.collectionView else { return }
        UICollectionView.itemHighlighted(collecionView: collectionView, indexPath: indexPath)
      })
      .disposed(by: disposeBag)
    
    collectionView.rx.itemUnhighlighted
      .asDriver()
      .drive(onNext: { [weak self] indexPath in
        guard let collectionView = self?.collectionView else { return }
        UICollectionView.itemUnhighlighted(collecionView: collectionView, indexPath: indexPath)
      })
      .disposed(by: disposeBag)
  }
  
  private func _configureFilterCollectionView() {
    let filterRegistration = UICollectionView.CellRegistration<HomeFilterCell, UUID> {
      [weak self] (cell, indexPath, id) in
      cell.display(cellModel: self?._filterDataSourceMap[id])
    }
    
    let addRegistration = UICollectionView.CellRegistration<HomeFilterAddCell, UUID> {
      [weak self] (cell, _, _)  in
      cell.delegate = self
    }
    
    let dataSource = HomeFilterDataSource (
      collectionView: filterCollectionView,
      cellProvider: { [weak self] (collectionView, indexPath, item) -> UICollectionViewCell in
        
        switch HomeFilterSection.init(rawValue: indexPath.section) {
          case .filter:
            guard let filterModel = self?._filterDataSourceMap[item] else { return UICollectionViewCell() }
            
            switch filterModel.isAdd {
              case true:
                return collectionView.dequeueConfiguredReusableCell(
                  using: addRegistration, for: indexPath, item: item
                )
                
              case false:
                return collectionView.dequeueConfiguredReusableCell(
                  using: filterRegistration, for: indexPath, item: item
                )
            }
            
          default: return UICollectionViewCell()
        }
      }
    )
    self._filterDataSourceManager = DataSourceSnapshotManager(dataSource: dataSource)
    filterCollectionView.dataSource = dataSource
  }
  
  private func _configureData() {
    self._filterDataSourceManager?.configureData()
    self._photoDataSourceManager?.configureData()
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
        dataSource.forEach { self?._filterDataSourceMap[$0.identity] = $0 }
        self?._filterDataSourceManager?.sectionAppendItems(
          section: .filter, items: dataSource.map { return $0.identity }
        )
      })
      .disposed(by: disposeBag)
  }
  
  private func _bindPhotoDataSource() {
    self._viewModel.output.photoDataSource
      .drive(onNext: { [weak self] dataSource in
        dataSource.forEach { self?._photoDataSourceMap[$0.identity] = $0 }
        self?._photoDataSourceManager?.sectionAppendItems(
          section: .photos, items: dataSource.map { return $0.identity }
        )
      })
      .disposed(by: disposeBag)
  }
  
  private func _bindNoDataSource() {
    self._viewModel.output.noDataSource
      .drive(onNext: { [weak self] dataSource in
        dataSource.forEach { self?._noDataSourceMap[$0.identity] = $0 }
        self?._photoDataSourceManager?.sectionAppendItems(
          section: .nodata, items: dataSource.map { return $0.identity }
        )
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
  
  private func _bindConfirmSelect() {
    self._viewModel.output.confirmSelect
      .compactMap { $0 }
      .drive(onNext: { [weak self] (indexPath, ientifier) in
        guard let self = self else { return }
        let detailViewController = DetailGiftiViewController(giftiIdentifier: ientifier)
        self._selectedIndexPath = indexPath
              
        detailViewController.transitioningDelegate = self
        detailViewController.modalPresentationStyle = .custom

        self.present(detailViewController, animated: true)

      })
      .disposed(by: disposeBag)
  }
  
  private func _bindDidDeleteNoData() {
    self._viewModel.output.didDeleteNoData
      .drive(onNext: { [weak self] noData in
        noData.forEach { identity in
          self?._noDataSourceMap[identity] = nil
        }
        self?._photoDataSourceManager?.deleteItems(items: noData)
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
    let filterViewController = FilterViewController()
    filterViewController.delegate = self
    self.present(filterViewController, animated: true)
  }
}

//MARK: - FilterViewControllerDelegate
extension HomeViewController: FilterViewControllerDelegate {
  func didSelectFilter(filters: [String]) {
    self._viewModel.input.selectedFilterList.onNext(filters)
  }
}

//MARK: - CollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
  func collectionView(
    _ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath
  ) {
    UICollectionView.itemHighlighted(collecionView: collectionView, indexPath: indexPath)
  }
  
  func collectionView(
    _ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath
  ) {
    UICollectionView.itemUnhighlighted(collecionView: collectionView, indexPath: indexPath)
  }
}


extension HomeViewController: UIViewControllerTransitioningDelegate {
  func animationController(
    forPresented presented: UIViewController,
    presenting: UIViewController,
    source: UIViewController
  ) -> UIViewControllerAnimatedTransitioning? {
    guard let destinationViewController = presented as? DestinationTransitionViewController else {
      return nil
    }
    
    return PresentAnimator(
      presenting: self,
      presented: destinationViewController,
      duration: 0.5
    )
  }
  
  func animationController(
    forDismissed dismissed: UIViewController
  ) -> UIViewControllerAnimatedTransitioning? {
    return nil
//    guard let destinationViewController = dismissed as? DestinationTransitionViewController else {
//      return nil
//    }
    
//    return DismissAnimator(
//      presenting: self,
//      presented: destinationViewController,
//      duration: 1
//    )
  }
}
