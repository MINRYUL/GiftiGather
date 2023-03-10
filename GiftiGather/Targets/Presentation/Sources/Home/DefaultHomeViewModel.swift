//
//  DefaultHomeViewmodel.swift
//  GiftiGather
//
//  Created by 김민창 on 2022/09/17.
//  Copyright © 2022 GiftiGather. All rights reserved.
//

import Foundation

import DIContainer
import Domain

import RxSwift
import RxCocoa

public struct DefaultHomeViewModel: HomeViewModel {
  public var disposeBag: DisposeBag = DisposeBag()
  
  public var input: HomeViewModelInput
  public var output: HomeViewModelOutput
  
  @Injected private var _writeGifticon: WriteGifticon
  @Injected private var _fetchGifticon: FetchGifticon
  
  //MARK: - Input
  private let _selectedImageIdentifers = PublishSubject<[String]>()
  private let _getGiftiCon = PublishSubject<Void>()
  private let _selectedFilterList = BehaviorSubject<[String]>(value: [])
  private let _selectedGifti = PublishSubject<IndexPath>()
  
  //MARK: - Output
  private let _filterDataSource = BehaviorSubject<[HomeFilterCellModel]>(value: [])
  private let _photoDataSource = BehaviorSubject<[HomePhotoCellModel]>(value: [])
  private let _noDataSource = BehaviorSubject<[NoDataCellModel]>(value: [])
  private let _confirmSelect = PublishSubject<(IndexPath, String)?>()
  private let _didDeleteNoData = PublishSubject<[UUID]>()
  private let _error = PublishSubject<Void>()
  
  //MARK: - Store
  private let _storePhotoDataSource = BehaviorRelay<[HomePhotoCellModel]>(value: [])
  
  public init() {
    self.input = HomeViewModelInput(
      selectedImageIdentifers: self._selectedImageIdentifers.asObserver(),
      getGiftiCon: self._getGiftiCon.asObserver(),
      selectedFilterList: self._selectedFilterList.asObserver(),
      selectedGifti: self._selectedGifti.asObserver()
    )
    
    self.output = HomeViewModelOutput(
      filterDataSource: self._filterDataSource.asDriver(onErrorJustReturn: []),
      photoDataSource: self._photoDataSource.asDriver(onErrorJustReturn: []),
      noDataSource: self._noDataSource.asDriver(onErrorJustReturn: []),
      confirmSelect: self._confirmSelect.asDriver(onErrorJustReturn: nil),
      didDeleteNoData: self._didDeleteNoData.asDriver(onErrorJustReturn: []),
      error: self._error.asDriver(onErrorJustReturn: ())
    )
    
    self._makeMockData()
    
    self._bindSelectedImageIdentifer()
    self._bindGetGiftiCon()
    self._bindSelectedGifti()
  }
}

//MARK: - Input Binding
extension DefaultHomeViewModel {
  private func _bindSelectedImageIdentifer() {
    self._selectedImageIdentifers
      .subscribe(onNext: { imageIdentifiers in
        let result = self._writeGifticon.writeGifticon(
          requestValue: imageIdentifiers.map { identifier -> GiftiInfoDTO in
            return GiftiInfoDTO(identifier: identifier)
          }
        )
        
        switch result {
          case .success(_):
            let photoCellModelList = imageIdentifiers.map { identifier -> HomePhotoCellModel in
              return HomePhotoCellModel(identity: UUID(), photoLocalIentifier: identifier)
            }
            var store = self._storePhotoDataSource.value
            store.append(contentsOf: photoCellModelList)
            self._storePhotoDataSource.accept(store)
            self._photoDataSource.onNext(photoCellModelList)
            
            guard let noDataSource = try? self._noDataSource.value(),
                  let noData = noDataSource.first else {
              return
            }
            
            self._didDeleteNoData.onNext([noData.identity])
            
          case .failure(_):
            self._error.onNext(())
        }
      })
      .disposed(by: disposeBag)
  }
  
  private func _bindGetGiftiCon() {
    self._getGiftiCon
      .map { _ -> [HomePhotoCellModel]? in
        let result = self._fetchGifticon.fetchGifticon()
        
        switch result {
          case .success(let response):
            if response.isEmpty {
              self._makeNoData()
              return nil
            }
            
            let dataSource = response.map { info -> HomePhotoCellModel in
              return HomePhotoCellModel(
                identity: UUID(),
                photoLocalIentifier: info.identifier
              )
            }
            
            self._storePhotoDataSource.accept(dataSource)
            return dataSource
            
          case .failure(_):
            self._error.onNext(())
            return nil
        }
      }
      .compactMap { $0 }
      .bind(to: self._photoDataSource)
      .disposed(by: disposeBag)
  }
  
  private func _bindSelectedFilterList() {
//    self._selectedFilterList
  }
  
  private func _bindSelectedGifti() {
    self._selectedGifti
      .map { indexPath -> (IndexPath, String)? in
        let dataSource = self._storePhotoDataSource.value
        
        if dataSource.isEmpty,
           dataSource.count <= indexPath.item {
          return nil
        }
        
        return (indexPath, dataSource[indexPath.item].photoLocalIentifier)
      }
      .bind(to: self._confirmSelect)
      .disposed(by: disposeBag)
  }
}

//MARK: - Making
extension DefaultHomeViewModel {
  private func _makeMockData() {
    self._filterDataSource.onNext([
      HomeFilterCellModel(
        identity: UUID(),
        title: "",
        isAdd: true
      ),
      HomeFilterCellModel(
        identity: UUID(),
        title: "전체",
        isAdd: false
      )
    ])
  }
  
  private func _makeNoData() {
    self._noDataSource.onNext([
      NoDataCellModel(identity: UUID(), titleKey: "noData")
    ])
  }
}
