//
//  NoDataCollectionViewcell.swift
//  GiftiGather
//
//  Created by 김민창 on 2022/09/17.
//  Copyright © 2022 GiftiGather. All rights reserved.
//

import UIKit

import Presentation

final class NoDataCollectionViewCell: BaseCollectionViewCell {
  private var _titleLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 18, weight: .semibold)
    label.textColor = .label
    label.numberOfLines = 0
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  override func viewDidInit() {
    super.viewDidInit()
    
    self.contentView.addSubview(self._titleLabel)
    
    NSLayoutConstraint.activate([
      self._titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50),
      self._titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50),
      self._titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      self._titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
    ])
  }
  
  func display(cellModel: NoDataCellModel?) {
    self._titleLabel.text = cellModel?.titleKey.localized()
  }
}

//MARK: - UI
extension NoDataCollectionViewCell {
  static func makeCollectionLayoutSection() -> NSCollectionLayoutSection {
    let item = NSCollectionLayoutItem(
      layoutSize: .init(
        widthDimension: .fractionalWidth(1),
        heightDimension: .fractionalWidth(1)
      )
    )
    item.contentInsets = .init(top: 3, leading: 3, bottom: 3, trailing: 3)
    
    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: .init(
        widthDimension: .fractionalWidth(1),
        heightDimension: .fractionalWidth(1)
      ),
      subitems: [item]
    )
    
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .none
    section.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
    
    return section
  }
}
