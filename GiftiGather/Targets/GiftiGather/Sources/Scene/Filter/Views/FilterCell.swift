//
//  FilterCell.swift
//  GiftiGather
//
//  Created by 김민창 on 2023/02/11.
//  Copyright © 2023 GiftiGather. All rights reserved.
//

import UIKit

import Presentation

final class FilterCell: BaseCollectionViewCell {
  lazy private var _containerView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .background
    view.layer.cornerRadius = 16
    view.layer.borderColor = UIColor.systemGray.cgColor
    view.layer.borderWidth = 1
    view.clipsToBounds = true
    return view
  }()
  
  lazy private var _titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .systemFont(ofSize: 16)
    label.textColor = .label
    return label
  }()
  
  override func viewDidInit() {
    super.viewDidInit()
    
    self._configureUI()
  }
  
  func display(cellModel: FilterCellModel?) {
    self._titleLabel.text = cellModel?.filter
  }
}

//MARK: - ConfigureUI
extension FilterCell {
  private func _configureUI() {
    self.contentView.addSubview(self._containerView)
    self._containerView.addSubview(self._titleLabel)
    
    NSLayoutConstraint.activate([
      self._containerView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
      self._containerView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
      self._containerView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
      self._containerView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
    ])
    
    NSLayoutConstraint.activate([
      self._titleLabel.topAnchor.constraint(equalTo: self._containerView.topAnchor, constant: 3),
      self._titleLabel.leadingAnchor.constraint(equalTo: self._containerView.leadingAnchor, constant: 12),
      self._titleLabel.trailingAnchor.constraint(equalTo: self._containerView.trailingAnchor, constant: -12),
      self._titleLabel.bottomAnchor.constraint(equalTo: self._containerView.bottomAnchor, constant: -3)
    ])
  }
}

//MARK: - UI
extension FilterCell {
  static func makeCollectionLayoutSection() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .estimated(100),
      heightDimension: .absolute(36)
    )
    let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
    
    let layoutGroupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: itemSize.heightDimension
    )
    let layoutGroup = NSCollectionLayoutGroup.horizontal(
      layoutSize: layoutGroupSize,
      subitems: [layoutItem]
    )
    
    layoutGroup.interItemSpacing = .fixed(8)
    
    let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
    layoutSection.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
    layoutSection.interGroupSpacing = 8
    
    return layoutSection
  }
}
