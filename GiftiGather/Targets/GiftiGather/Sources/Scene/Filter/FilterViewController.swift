//
//  FilterViewController.swift
//  GiftiGather
//
//  Created by 김민창 on 2023/02/06.
//  Copyright © 2023 GiftiGather. All rights reserved.
//

import UIKit

import DIContainer
import Presentation

enum FilterSection: Int, CaseIterable {
  case filter, noData
}

protocol FilterViewControllerDelegate: AnyObject {
  func didSelectFilter(filters: [String])
}

final class FilterViewController: BaseViewController {
  //MARK: - Typealias
  typealias FilterDataSource = UICollectionViewDiffableDataSource<FilterSection, AnyHashable>
  typealias SourceSnapshot = NSDiffableDataSourceSnapshot<FilterSection, AnyHashable>
    
  //MARK: - View
  lazy var collectionView: UICollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    let collectionView = UICollectionView(frame: .init(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: flowLayout)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
    return collectionView
  }()
  
  lazy var addContainerView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 24, weight: .semibold)
    label.text = "filter".localized()
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  lazy var addButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
    button.tintColor = .label
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  lazy var addFooterView: UIView = {
    let view = UIView()
    view.backgroundColor = .background
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private var _dataSource: FilterDataSource?
  
  //MARK: - Injection
  @Injected private var _viewModel: FilterViewModel
  
  weak var delegate: FilterViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.configureUI()
    self._configureTarget()
    self._configureDataSource()
    self._configureData()
    
    self._bindFilterDataSource()
    self._bindNoDataDataSource()
    
    self._viewModel.input.getFilter.onNext(())
  }
}

//MARK: - Configure
extension FilterViewController {
  private func _configureTarget() {
    self.addButton.addTarget(self, action: #selector(_addAction), for: .touchUpInside)
  }
  
  private func _configureDataSource() {
    let filterRegistration = UICollectionView.CellRegistration<FilterCell, FilterCellModel> {
      (cell, indexPath, cellModel) in
      cell.display(cellModel: cellModel)
    }
    
    let noDataRegistration = UICollectionView.CellRegistration<NoDataCollectionViewCell, NoDataCellModel> {
      (cell, indexPath, cellModel) in
      cell.display(cellModel: cellModel)
    }
    
    let dataSource = FilterDataSource (
      collectionView: collectionView,
      cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell in
        
        switch FilterSection.init(rawValue: indexPath.section) {
          case .filter:
            return collectionView.dequeueConfiguredReusableCell(
              using: filterRegistration, for: indexPath, item: item as? FilterCellModel
            )
            
          case .noData:
            return collectionView.dequeueConfiguredReusableCell(
              using: noDataRegistration, for: indexPath, item: item as? NoDataCellModel
            )
            
          default: return UICollectionViewCell()
        }
      })
    
    self._dataSource = dataSource
    collectionView.dataSource = dataSource
  }
  
  private func _configureData() {
    var snapshot = SourceSnapshot()
    FilterSection.allCases.forEach {
      snapshot.appendSections([$0])
    }
    self._dataSource?.apply(snapshot, animatingDifferences: true)
  }
}

//MARK: - Action
extension FilterViewController {
  @objc private func _addAction() {
    let alert = UIAlertController(
      title: nil,
      message: nil,
      preferredStyle: UIAlertController.Style.actionSheet
    )
    let addAction =  UIAlertAction(
      title: "add".localized(),
      style: UIAlertAction.Style.default,
      handler: { [weak self] _ in
      }
    )
    let deleteAction =  UIAlertAction(
      title: "delete".localized(),
      style: UIAlertAction.Style.destructive,
      handler: { [weak self] _ in
      }
    )
    
    let cancelAction = UIAlertAction(
      title: "cancel".localized(), style: UIAlertAction.Style.cancel
    )
    
    alert.addAction(addAction)
    alert.addAction(deleteAction)
    alert.addAction(cancelAction)
    
    self.present(alert, animated: false)
  }
}

//MARK: - Output Binding
extension FilterViewController {
  private func _bindFilterDataSource() {
    self._viewModel.output.filterDataSource
      .drive(onNext: { [weak self] dataSource in
        self?._sectionSnapShotApply(section: .filter, item: dataSource)
      })
      .disposed(by: disposeBag)
  }
  
  private func _bindNoDataDataSource() {
    self._viewModel.output.noDataSource
      .drive(onNext: { [weak self] dataSource in
        self?._sectionSnapShotApply(section: .noData, item: dataSource)
      })
      .disposed(by: disposeBag)
  }
}

//MARK: - Apply
extension FilterViewController {
  private func _sectionSnapShotApply(section: FilterSection, item: [AnyHashable]) {
    guard var snapshot = self._dataSource?.snapshot() else { return }
    item.forEach {
      snapshot.appendItems([$0], toSection: section)
    }
    self._dataSource?.apply(snapshot, animatingDifferences: true)
  }
  
  private func _deleteSection(section: FilterSection) {
    guard var snapshot = self._dataSource?.snapshot() else { return }
    snapshot.deleteSections([section])
    self._dataSource?.apply(snapshot, animatingDifferences: false)
  }
}
