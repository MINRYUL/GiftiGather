//
//  FilterViewController.swift
//  GiftiGather
//
//  Created by 김민창 on 2023/02/06.
//  Copyright © 2023 GiftiGather. All rights reserved.
//

import UIKit

enum FilterSection: Int, CaseIterable {
  case filter, noData
}

final class FilterViewController: BaseViewController {
  //MARK: - Typealias
  typealias HomeDataSource = UICollectionViewDiffableDataSource<FilterSection, AnyHashable>
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
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.configureUI()
    self._configureTarget()
  }
}

//MARK: - Configure
extension FilterViewController {
  private func _configureTarget() {
    self.addButton.addTarget(self, action: #selector(_addAction), for: .touchUpInside)
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
