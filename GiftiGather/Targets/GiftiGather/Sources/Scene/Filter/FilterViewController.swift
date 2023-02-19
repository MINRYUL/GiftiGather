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
  typealias FilterDataSource = UICollectionViewDiffableDataSource<FilterSection, UUID>
  typealias SourceSnapshot = NSDiffableDataSourceSnapshot<FilterSection, UUID>
    
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
  
  private var _dataSourceManage: DataSourceSnapshotManager<FilterSection>?
  private var _filterDataSourceMap = [UUID: FilterCellModel]()
  private var _noDataSourceMap = [UUID: NoDataCellModel]()
  
  //MARK: - Injection
  @Injected private var _viewModel: FilterViewModel
  
  weak var delegate: FilterViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.configureUI()
    self._configureTarget()
    self._configureDataSource()
    self._configureData()
    
    self._bindCollectionView()
    
    self._bindFilterDataSource()
    self._bindNoDataDataSource()
    self._bindUpdateItem()
    self._bindError()
    
    self._viewModel.input.getFilter.onNext(())
  }
}

//MARK: - Configure
extension FilterViewController {
  private func _configureTarget() {
    self.addButton.addTarget(self, action: #selector(_addAction), for: .touchUpInside)
  }
  
  private func _configureDataSource() {
    let filterRegistration = UICollectionView.CellRegistration<FilterCell, UUID> {
      [weak self] (cell, indexPath, id) in
      cell.display(cellModel: self?._filterDataSourceMap[id])
    }
    
    let noDataRegistration = UICollectionView.CellRegistration<NoDataCollectionViewCell, UUID> {
      [weak self] (cell, indexPath, id) in
      cell.display(cellModel: self?._noDataSourceMap[id])
    }
    
    let dataSource = FilterDataSource (
      collectionView: collectionView,
      cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell in
        
        switch FilterSection.init(rawValue: indexPath.section) {
          case .filter:
            return collectionView.dequeueConfiguredReusableCell(
              using: filterRegistration, for: indexPath, item: item
            )
            
          case .noData:
            return collectionView.dequeueConfiguredReusableCell(
              using: noDataRegistration, for: indexPath, item: item
            )
            
          default: return UICollectionViewCell()
        }
      })
    
    self._dataSourceManage = DataSourceSnapshotManager(dataSource: dataSource)
    collectionView.dataSource = dataSource
  }
  
  private func _configureData() {
    self._dataSourceManage?.configureData()
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
        let controller = UIAlertController(
          title: nil,
          message: "gifticon_input_filter".localized(),
          preferredStyle: .alert
        )
        
        controller.addTextField { field in
          field.borderStyle = .none
        }
        
        let okAction = UIAlertAction(title: "confirm".localized(), style: .default) { action in
          if let filter = controller.textFields?.first?.text {
            self?._viewModel.input.storeFilter.onNext(filter)
          }
        }
        
        controller.addAction(okAction)
        self?.present(controller, animated: true)
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

//MARK: - Input Binding
extension FilterViewController {
  private func _bindCollectionView() {
    self.collectionView.rx.itemSelected
      .bind(to: self._viewModel.input.didSelectIndex)
      .disposed(by: disposeBag)
  }
}

//MARK: - Output Binding
extension FilterViewController {
  private func _bindFilterDataSource() {
    self._viewModel.output.filterDataSource
      .drive(onNext: { [weak self] dataSource in
        dataSource.forEach { self?._filterDataSourceMap[$0.identity] = $0 }
        self?._dataSourceManage?.sectionAppendItems(
          section: .filter, items: dataSource.map { return $0.identity }
        )
      })
      .disposed(by: disposeBag)
  }
  
  private func _bindNoDataDataSource() {
    self._viewModel.output.noDataSource
      .drive(onNext: { [weak self] dataSource in
        dataSource.forEach { self?._noDataSourceMap[$0.identity] = $0 }
        self?._dataSourceManage?.sectionAppendItems(
          section: .noData, items: dataSource.map { return $0.identity }
        )
      })
      .disposed(by: disposeBag)
  }
  
  private func _bindUpdateItem() {
    self._viewModel.output.updateItem
      .compactMap { $0 }
      .drive(onNext: { [weak self] item in
        self?._filterDataSourceMap[item.identity] = item
        self?._dataSourceManage?.reconfigureItems(items: [item.identity])
      })
      .disposed(by: disposeBag)
  }
  
  private func _bindError() {
    self._viewModel.output.error
      .drive(onNext: { [weak self] error in
        self?.showToast(message: error.localized())
      })
      .disposed(by: disposeBag)
  }
}
