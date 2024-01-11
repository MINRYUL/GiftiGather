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
  private let _didTouchConfirm = PublishSubject<Void>()
  private let _didTouchDelete = PublishSubject<Void>()
  
  //MARK: - Output
  private let _filterDataSource = BehaviorSubject<[FilterCellModel]>(value: [])
  private let _noDataSource = BehaviorSubject<[NoDataCellModel]>(value: [])
  private let _updateItems = PublishSubject<[FilterCellModel]?>()
  private let _isDeleteMode = BehaviorSubject<Bool>(value: false)
  private let _didDeleteFilters = PublishSubject<[UUID]>()
  private let _didDeleteNoData = PublishSubject<[UUID]>()
  private let _error = PublishSubject<String>()
  private let _confirm = PublishSubject<[String]>()
  
  //MARK: - Store
  private let _storeDataSource = BehaviorRelay<[FilterCellModel]>(value: [])
  
  
  public init() {
    self.input = FilterViewModelInput(
      getFilter: self._getFilter.asObserver(),
      storeFilter: self._storeFilter.asObserver(),
      didSelectIndex: self._didSelectIndex.asObserver(),
      didTouchConfirm: self._didTouchConfirm.asObserver(),
      didTouchDelete: self._didTouchDelete.asObserver()
    )
    
    self.output = FilterViewModelOutput(
      filterDataSource: self._filterDataSource.asDriver(onErrorJustReturn: []),
      noDataSource: self._noDataSource.asDriver(onErrorJustReturn: []),
      updateItems: self._updateItems.asDriver(onErrorJustReturn: nil),
      isDeleteMode: self._isDeleteMode.asDriver(onErrorJustReturn: false),
      didDeleteFilters: self._didDeleteFilters.asDriver(onErrorJustReturn: []),
      didDeleteNoData: self._didDeleteNoData.asDriver(onErrorJustReturn: []),
      error: self._error.asDriver(onErrorJustReturn: String()),
      confirm: self._confirm.asDriver(onErrorJustReturn: [])
    )
    
    self._bindGetFilter()
    self._bindStoreFilter()
    self._bindDidSelectIndex()
    self._bindDidTouchConfirm()
    self._bindDidTouchDelete()
  }
}

//MARK: - Input Binding
extension DefaultFilterViewModel {
  private func _bindGetFilter() {
    self._getFilter
      .subscribe(onNext: {
        let result = self._fetchFilter.fetchFilter()
        let isDeleteMode = (try? self._isDeleteMode.value()) ?? false
        
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
                isCheck: false,
                isDeleteMode: isDeleteMode
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
        if filter.isEmpty { return }
        
        var filterList: [FilterCellModel] = self._storeDataSource.value
        let isDeleteMode = (try? self._isDeleteMode.value()) ?? false
        
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
              isCheck: false,
              isDeleteMode: isDeleteMode
            )
            filterList.append(filterCellModel)
            self._storeDataSource.accept(filterList)
            self._filterDataSource.onNext([filterCellModel])

            guard let noDataSource = try? self._noDataSource.value(),
                  let noData = noDataSource.first else {
              return
            }
            
            self._didDeleteNoData.onNext([noData.identity])
            
          case .failure(_): return
        }
      })
      .disposed(by: disposeBag)
  }
  
  private func _bindDidSelectIndex() {
    self._didSelectIndex
      .map { indexPath -> [FilterCellModel] in
        let isDeleteMode = (try? self._isDeleteMode.value()) ?? false
        var dataSource = self._storeDataSource.value
        var filterCellModel: FilterCellModel?
        
        dataSource = dataSource.enumerated().map { index, item in
          switch index == indexPath.item {
            case true:
              let changeItem = FilterCellModel(
                identity: item.identity,
                filter: item.filter,
                isCheck: !item.isCheck,
                isDeleteMode: isDeleteMode
              )
              filterCellModel = changeItem
              return changeItem
            case false: return item
          }
        }
        
        self._storeDataSource.accept(dataSource)
        return [filterCellModel].compactMap { $0 }
      }
      .compactMap { $0 }
      .bind(to: _updateItems)
      .disposed(by: disposeBag)
  }
  
  private func _bindDidTouchConfirm() {
    self._didTouchConfirm
      .map { _ -> [String]? in
        guard let isDeleteMode = try? self._isDeleteMode.value() else { return [] }
        switch isDeleteMode {
          case true:
            let resultDataSource = self._storeDataSource.value.filter { item in
              return !item.isCheck
            }
            
            let removeList = self._storeDataSource.value.filter { item  in
              return item.isCheck
            }.map { $0.filter }
            
            let uuidList = self._storeDataSource.value.filter { item  in
              return item.isCheck
            }.map { $0.identity }
            
            removeList.forEach { remove in
              let _ = self._deleteFilter.deleteFilter(requestValue: remove)
            }
            self._storeDataSource.accept(resultDataSource)
            self._didDeleteFilters.onNext(uuidList)
            
            if resultDataSource.isEmpty {
              self._noDataSource.onNext([NoDataCellModel(titleKey: "noFilter")])
            }
            
            return nil
            
          case false:
            return self._storeDataSource.value.map { item -> String in
              return item.filter
            }
        }
      }
      .compactMap { $0 }
      .bind(to: self._confirm)
      .disposed(by: disposeBag)
  }
  
  private func _bindDidTouchDelete() {
    self._didTouchDelete
      .map { _ -> Bool in
        guard let isDeleteMode = try? self._isDeleteMode.value() else { return false }
        let dataSource = self._storeDataSource.value
        
        let updateItems = dataSource.map {
          return FilterCellModel(
            identity: $0.identity,
            filter: $0.filter,
            isCheck: $0.isCheck,
            isDeleteMode: !isDeleteMode
          )
        }
        
        self._storeDataSource.accept(updateItems)
        self._updateItems.onNext(updateItems)
        return !isDeleteMode
      }
      .bind(to: _isDeleteMode)
      .disposed(by: disposeBag)
  }
}
