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
  
  //MARK: - Output
  private let _filterDataSource = BehaviorSubject<[HomeFilterCellModel]>(value: [])
  private let _photoDataSource = BehaviorSubject<[HomePhotoCellModel]>(value: [])
  private let _noDataSource = BehaviorSubject<[NoDataCellModel]>(value: [])

  public init() {
    self.input = HomeViewModelInput(
    )
    
    self.output = HomeViewModelOutput(
      filterDataSource: self._filterDataSource.asDriver(onErrorJustReturn: []),
      photoDataSource: self._photoDataSource.asDriver(onErrorJustReturn: []),
      noDataSource: self._noDataSource.asDriver(onErrorJustReturn: [])
    )
    
    self._makeMockData()
  }
  
  private func _makeMockData() {
    self._filterDataSource.onNext([
      HomeFilterCellModel(
        identity: UUID(),
        title: "전체"
      ),
      HomeFilterCellModel(
        identity: UUID(),
        title: "치킨"
      ),
      HomeFilterCellModel(
        identity: UUID(),
        title: "긴 필터를 넣어보자"
      ),
      HomeFilterCellModel(
        identity: UUID(),
        title: "피자"
      ),
      HomeFilterCellModel(
        identity: UUID(),
        title: "커피"
      ),
      HomeFilterCellModel(
        identity: UUID(),
        title: "매우매우매우매우 매우매우매우매우 매우매우매우매우 매우매우매우매우 긴 필터를 넣어보자"
      ),
      HomeFilterCellModel(
        identity: UUID(),
        title: "긴 필터를 넣어보자"
      )
    ])
    
    self._photoDataSource.onNext([
      HomePhotoCellModel(identity: UUID()),
      HomePhotoCellModel(identity: UUID()),
      HomePhotoCellModel(identity: UUID()),
      HomePhotoCellModel(identity: UUID()),
      HomePhotoCellModel(identity: UUID()),
      HomePhotoCellModel(identity: UUID()),
      HomePhotoCellModel(identity: UUID()),
      HomePhotoCellModel(identity: UUID()),
      HomePhotoCellModel(identity: UUID()),
      HomePhotoCellModel(identity: UUID()),
      HomePhotoCellModel(identity: UUID()),
      HomePhotoCellModel(identity: UUID()),
      HomePhotoCellModel(identity: UUID()),
      HomePhotoCellModel(identity: UUID()),
      HomePhotoCellModel(identity: UUID()),
      HomePhotoCellModel(identity: UUID()),
      HomePhotoCellModel(identity: UUID()),
      HomePhotoCellModel(identity: UUID()),
      HomePhotoCellModel(identity: UUID()),
      HomePhotoCellModel(identity: UUID()),
      HomePhotoCellModel(identity: UUID()),
      HomePhotoCellModel(identity: UUID()),
      HomePhotoCellModel(identity: UUID()),
      HomePhotoCellModel(identity: UUID()),
      HomePhotoCellModel(identity: UUID()),
      HomePhotoCellModel(identity: UUID()),
      HomePhotoCellModel(identity: UUID()),
      HomePhotoCellModel(identity: UUID()),
      HomePhotoCellModel(identity: UUID())
    ])
  }
  
}
