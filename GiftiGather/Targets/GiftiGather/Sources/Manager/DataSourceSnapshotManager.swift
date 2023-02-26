//
//  DataSourceSnapshotManager.swift
//  GiftiGather
//
//  Created by Jerry on 2023/02/19.
//  Copyright © 2023 GiftiGather. All rights reserved.
//

import UIKit

final class DataSourceSnapshotManager<Section: Hashable> where Section: CaseIterable {
  typealias DataSource = UICollectionViewDiffableDataSource<Section, UUID>
  typealias SourceSnapshot = NSDiffableDataSourceSnapshot<Section, UUID>
  
  private let _dataSource: DataSource
  
  init(dataSource: DataSource) {
    self._dataSource = dataSource
  }
  
  func configureData() {
    var snapshot = SourceSnapshot()
    Section.allCases.forEach {
      snapshot.appendSections([$0])
    }
    self._dataSource.apply(snapshot, animatingDifferences: true)
  }
  
  func reconfigureItems(items: [UUID]) {
    var snapshot = _dataSource.snapshot()
    snapshot.reconfigureItems(items)
    _dataSource.apply(snapshot, animatingDifferences: true)
  }
  
  func reloadItems(items: [UUID]) {
    var snapshot = _dataSource.snapshot()
    snapshot.reloadItems(items)
    _dataSource.apply(snapshot, animatingDifferences: true)
  }
  
  func sectionAppendItems(
    section: Section, items: [UUID]
  ) {
    var snapshot = _dataSource.snapshot()
    items.forEach {
      snapshot.appendItems([$0], toSection: section)
    }
    _dataSource.apply(snapshot, animatingDifferences: true)
  }
  
  func sectionConfigure(
    section: Section, items: [UUID]
  ) {
    DispatchQueue.global().sync {
      var snapshot = SourceSnapshot()
      snapshot.appendSections([section])
      snapshot.appendItems(items, toSection: section)
      self._dataSource.apply(snapshot, animatingDifferences: true)
    }
  }
  
  func sectionDelete(section: Section) {
    var snapshot = self._dataSource.snapshot()
    snapshot.deleteSections([section])
    self._dataSource.apply(snapshot, animatingDifferences: false)
  }
  
  func deleteItems(items: [UUID]) {
    var snapshot = self._dataSource.snapshot()
    snapshot.deleteItems(items)
    self._dataSource.apply(snapshot, animatingDifferences: false)
  }
}
