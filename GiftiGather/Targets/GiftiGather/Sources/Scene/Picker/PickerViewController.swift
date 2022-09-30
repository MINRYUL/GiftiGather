//
//  PickerViewController.swift
//  PresentationTests
//
//  Created by 김민창 on 2022/09/26.
//  Copyright © 2022 GiftiGather. All rights reserved.
//

import UIKit
import DIContainer
import Presentation

import RxSwift
import RxCocoa

enum PickerSection: Int, CaseIterable {
  case pick
}

final class PickerViewController: BaseViewController {
  //MARK: - Typealias
  typealias PickerDataSource = UICollectionViewDiffableDataSource<PickerSection, AnyHashable>
  typealias SourceSnapshot = NSDiffableDataSourceSnapshot<PickerSection, AnyHashable>
  
  //MARK: - View
  lazy var collectionView: UICollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    let collectionView = UICollectionView(frame: .init(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: flowLayout)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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
    label.text = "gifticon".localized()
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  lazy var addButton: UIButton = {
    let button = UIButton()
    button.setTitle("add".localized(), for: .normal)
    button.setTitleColor(UIColor.systemBlue, for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  lazy var addFooterView: UIView = {
    let view = UIView()
    view.backgroundColor = .background
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private var _dataSource: PickerDataSource?
  
  //MARK: - Injection
  @Injected private var _viewModel: PickerViewModel
  
  //MARK: - Observer
  var imageIdentifierList: [String]? {
    didSet {
      guard let imageIdentifierList = imageIdentifierList else {
        return
      }
      self._viewModel.input.imageIdentifierList.onNext(imageIdentifierList)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.configureUI()
    
    self._configureRegister()
    self._configureDataSource()
    self._configureData()
    
    self._bindDataSource()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    self.showToast("msg_add_image".localized())
  }
  
  //MARK: - Configure
  private func _configureRegister() {
    PickerCell.register(to: self.collectionView)
  }
  
  private func _configureDataSource() {
      let dataSource = PickerDataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell in
        
        switch PickerSection.init(rawValue: indexPath.section) {
          case .pick:
            guard let cell = collectionView.dequeueReusableCell(
              withReuseIdentifier: PickerCell.identifier,
              for: indexPath
            ) as? PickerCell,
                  let item = item as? PickCellModel
            else  { return UICollectionViewCell() }
            
            cell.display(cellModel: item)
            
            return cell
            
          default: return UICollectionViewCell()
            
        }
      })
      
      self._dataSource = dataSource
      collectionView.dataSource = dataSource
  }
  
  private func _configureData() {
    var snapshot = SourceSnapshot()
    PickerSection.allCases.forEach {
      snapshot.appendSections([$0])
    }
    self._dataSource?.apply(snapshot, animatingDifferences: true)
  }
}

extension PickerViewController {
  private func _bindDataSource() {
    self._viewModel.output.dataSource
      .drive(onNext: { [weak self] dataSource in
        self?._sectionSnapShotApply(section: .pick, item: dataSource)
      })
      .disposed(by: disposeBag)
  }
}

//MARK: - Apply
extension PickerViewController {
  private func _sectionSnapShotApply(section: PickerSection, item: [AnyHashable]) {
    DispatchQueue.global().sync {
      guard var snapshot = self._dataSource?.snapshot() else { return }
      item.forEach {
        snapshot.appendItems([$0], toSection: section)
      }
      self._dataSource?.apply(snapshot, animatingDifferences: true)
    }
  }
}
