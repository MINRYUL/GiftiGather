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
  private let _didSelectIndex = PublishSubject<IndexPath>()
  
  //MARK: - Output
  private let _filterDataSource = BehaviorSubject<[FilterCellModel]>(value: [])
  private let _noDataSource = BehaviorSubject<[NoDataCellModel]>(value: [])
  private let _updateItem = PublishSubject<FilterCellModel?>()
  private let _error = PublishSubject<String>()
  
  //MARK: - Store
  private let _storeDataSource = BehaviorRelay<[FilterCellModel]>(value: [])
  
  public init() {
    self.input = FilterViewModelInput(
      getFilter: self._getFilter.asObserver(),
      storeFilter: self._storeFilter.asObserver(),
      didSelectIndex: self._didSelectIndex.asObserver()
    )
    
    self.output = FilterViewModelOutput(
      filterDataSource: self._filterDataSource.asDriver(onErrorJustReturn: []),
      noDataSource: self._noDataSource.asDriver(onErrorJustReturn: []),
      updateItem: self._updateItem.asDriver(onErrorJustReturn: nil),
      error: self._error.asDriver(onErrorJustReturn: String())
    )
    
    self._bindGetFilter()
    self._bindStoreFilter()
    self._bindDidSelectIndex()
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
                filter: $0,
                isCheck: false
              )
            }
            self._storeDataSource.accept(filterList)
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
        var filterList: [FilterCellModel] = self._storeDataSource.value
        
        for filterInfo in filterList {
          if filterInfo.filter == filter {
            self._error.onNext("msg_already_filter")
            return
          }
        }
        
        let result = self._writeFilter.writeFilter(requestValue: filter)

        switch result {
          case .success(_):
            let filterCellModel = FilterCellModel(
              identity: UUID(),
              filter: filter,
              isCheck: false
            )
            filterList.append(filterCellModel)
            self._storeDataSource.accept(filterList)
            self._filterDataSource.onNext([filterCellModel])

          case .failure(_): return
        }
      })
      .disposed(by: disposeBag)
  }
  
  private func _bindDidSelectIndex() {
    self._didSelectIndex
      .map { indexPath -> FilterCellModel? in
        var dataSource = self._storeDataSource.value
        var filterCellModel: FilterCellModel?
        
        dataSource = dataSource.enumerated().map { index, item in
          switch index == indexPath.item {
            case true:
              let changeItem = FilterCellModel(
                identity: item.identity,
                filter: item.filter,
                isCheck: !item.isCheck
              )
              filterCellModel = changeItem
              return changeItem
            case false: return item
          }
        }
        
        self._storeDataSource.accept(dataSource)
        return filterCellModel
      }
      .compactMap { $0 }
      .bind(to: _updateItem)
      .disposed(by: disposeBag)
  }
}
