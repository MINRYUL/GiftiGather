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

protocol PickerViewControllerDelegate: AnyObject {
  func didSelectImageIdentifiers(
    _ viewController: PickerViewController, imageIdentifiers: [String]
  )
}

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
  
  weak var delegate: PickerViewControllerDelegate?
  
  //MARK: - Injection
  @Injected private var _viewModel: PickerViewModel
  
  //MARK: - Observer
  var imageIdentifierListWithCheck: ([String], Bool)? {
    didSet {
      guard let imageIdentifierListWithCheck = imageIdentifierListWithCheck else {
        return
      }
      self._viewModel.input.imageIdentifierList.onNext(imageIdentifierListWithCheck)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.configureUI()
    
    self._configureRegister()
    self._configureDataSource()
    
    self._bindTableView()
    self._bindDidTouchAdd()
    
    self._bindDataSource()
    self._bindSelectedImageIdentifiers()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    self.showToast("msg_add_image".localized())
  }
  
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
}

//MARK: - Input Binding
extension PickerViewController {
  private func _bindTableView() {
    self.collectionView.rx.itemSelected
      .bind(to: self._viewModel.input.didSelectIndex)
      .disposed(by: disposeBag)
  }
  
  private func _bindDidTouchAdd() {
    self.addButton.rx.tap
      .bind(to: self._viewModel.input.didTouchAdd)
      .disposed(by: disposeBag)
  }
}

//MARK: - Output Binding
extension PickerViewController {
  private func _bindDataSource() {
    self._viewModel.output.dataSource
      .drive(onNext: { [weak self] dataSource in
        self?._sectionSnapShotApply(section: .pick, item: dataSource)
      })
      .disposed(by: disposeBag)
  }
  
  private func _bindSelectedImageIdentifiers() {
    self._viewModel.output.selectedImageIdentifiers
      .drive(onNext: { [weak self] imageIdentifiers in
        guard let self = self else { return }
        
        self.dismiss(animated: true, completion: {
          self.delegate?.didSelectImageIdentifiers(
            self, imageIdentifiers: imageIdentifiers
          )
        })
      })
      .disposed(by: disposeBag)
  }
}

//MARK: - Apply
extension PickerViewController {
  private func _sectionSnapShotApply(section: PickerSection, item: [AnyHashable]) {
    DispatchQueue.global().sync {
      var snapshot = SourceSnapshot()
      snapshot.appendSections([section])
      snapshot.appendItems(item, toSection: section)
      self._dataSource?.apply(snapshot, animatingDifferences: true)
    }
  }
}
