//
//  DefaultHomeViewmodel.swift
//  GiftiGather
//
//  Created by 김민창 on 2022/09/17.
//  Copyright © 2022 GiftiGather. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

public struct DefaultHomeViewModel: HomeViewModel {
  public var disposeBag: DisposeBag = DisposeBag()
  
  public var input: HomeViewModelInput
  public var output: HomeViewModelOutput
  
  //MARK: - Input
  private let _selectedImageIdentifers = PublishSubject<[String]>()
  
  //MARK: - Output
  private let _filterDataSource = BehaviorSubject<[HomeFilterCellModel]>(value: [])
  private let _photoDataSource = BehaviorSubject<[HomePhotoCellModel]>(value: [])
  private let _noDataSource = BehaviorSubject<[NoDataCellModel]>(value: [])

  public init() {
    self.input = HomeViewModelInput(
      selectedImageIdentifers: self._selectedImageIdentifers.asObserver()
    )
    
    self.output = HomeViewModelOutput(
      filterDataSource: self._filterDataSource.asDriver(onErrorJustReturn: []),
      photoDataSource: self._photoDataSource.asDriver(onErrorJustReturn: []),
      noDataSource: self._noDataSource.asDriver(onErrorJustReturn: [])
    )
    
    self._makeMockData()
    
    self._bindSelectedImageIdentifer()
  }
  
  private func _makeMockData() {
    self._filterDataSource.onNext([
      HomeFilterCellModel(
        identity: UUID(),
        title: "전체"
      )
    ])
    
    self._makeNoData()
  }
  
  private func _makeNoData() {
    self._noDataSource.onNext([
      NoDataCellModel(identity: UUID(), titleKey: "noData")
    ])
  }
}

//MARK: - Input Binding
extension DefaultHomeViewModel {
  private func _bindSelectedImageIdentifer() {
    self._selectedImageIdentifers
      .subscribe(onNext: { imageIdentifiers in
        
      })
      .disposed(by: disposeBag)
  }
}

//MARK: - Output Binding
extension DefaultHomeViewModel {
  
}
