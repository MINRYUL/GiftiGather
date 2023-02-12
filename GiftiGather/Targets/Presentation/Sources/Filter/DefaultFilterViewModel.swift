//
//  DefaultFilterViewModel.swift
//  GiftiGather
//
//  Created by 김민창 on 2023/02/08.
//  Copyright © 2023 GiftiGather. All rights reserved.
//

import Foundation

import DIContainer
import Domain

import RxSwift
import RxCocoa

public struct DefaultFilterViewModel: FilterViewModel {
  public var disposeBag: DisposeBag = DisposeBag()
  
  public var input: FilterViewModelInput
  public var output: FilterViewModelOutput
  
  @Injected private var _writeFilter: WriteFilter
  @Injected private var _fetchFilter: FetchFilter
  @Injected private var _deleteFilter: DeleteFilter
  
  //MARK: - Input
  private let _getFilter = PublishSubject<Void>()
  private let _storeFilter = BehaviorSubject<String?>(value: nil)
  
  //MARK: - Output
  private let _filterDataSource = BehaviorSubject<[FilterCellModel]>(value: [])
  private let _noDataSource = BehaviorSubject<[NoDataCellModel]>(value: [])
  
  //MARK: - Store
  private let _storeFilterList = BehaviorRelay<[String]>(value: [])
  
  public init() {
    self.input = FilterViewModelInput(
      getFilter: self._getFilter.asObserver(),
      storeFilter: self._storeFilter.asObserver()
    )
    
    self.output = FilterViewModelOutput(
      filterDataSource: self._filterDataSource.asDriver(onErrorJustReturn: []),
      noDataSource: self._noDataSource.asDriver(onErrorJustReturn: [])
    )
    
    self._bindGetFilter()
    self._bindStoreFilter()
  }
}

//MARK: - Input Binding
extension DefaultFilterViewModel {
  private func _bindGetFilter() {
    self._getFilter
      .subscribe(onNext: {
        let result = self._fetchFilter.fetchFilter()
        
        switch result {
          case .success(let response):
            if response.isEmpty {
              self._noDataSource.onNext([NoDataCellModel(titleKey: "noFilter")])
              return
            }
            
            let filterList = response.map {
              return FilterCellModel(
                identity: UUID(),
                filter: $0
              )
            }
            self._storeFilterList.accept(response)
            self._filterDataSource.onNext(filterList)
            
          case .failure(_):
            self._noDataSource.onNext([NoDataCellModel(titleKey: "noFilter")])
        }
      })
      .disposed(by: disposeBag)
  }
  
  private func _bindStoreFilter() {
    self._storeFilter
      .compactMap { $0 }
      .subscribe(onNext: { filter in
        let filterList = self._storeFilterList.value
        
        for filterInfo in filterList {
          if filterInfo == filter { return }
        }
        
        let result = self._writeFilter.writeFilter(requestValue: filter)
        
        switch result {
          case .success(_):
            let filterList = self._storeFilterList.value
            self._storeFilterList.accept([filterList, [filter]].flatMap { $0 })
            self._filterDataSource.onNext([
              FilterCellModel(
                identity: UUID(),
                filter: filter
              )
            ])
            
          case .failure(_): return
        }
      })
      .disposed(by: disposeBag)
  }
}
