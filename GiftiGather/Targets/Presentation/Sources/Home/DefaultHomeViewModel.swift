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
  
  //MARK: - Output
  private let _filterDataSource = BehaviorSubject<[HomeFilterCellModel]>(value: [])
  private let _photoDataSource = BehaviorSubject<[HomePhotoCellModel]>(value: [])
  private let _noDataSource = BehaviorSubject<[NoDataCellModel]>(value: [])
  private let _error = PublishSubject<Void>()
  
  public init() {
    self.input = HomeViewModelInput(
      selectedImageIdentifers: self._selectedImageIdentifers.asObserver(),
      getGiftiCon: self._getGiftiCon.asObserver()
    )
    
    self.output = HomeViewModelOutput(
      filterDataSource: self._filterDataSource.asDriver(onErrorJustReturn: []),
      photoDataSource: self._photoDataSource.asDriver(onErrorJustReturn: []),
      noDataSource: self._noDataSource.asDriver(onErrorJustReturn: []),
      error: self._error.asDriver(onErrorJustReturn: ())
    )
    
    self._makeMockData()
    
    self._bindSelectedImageIdentifer()
    self._bindGetGiftiCon()
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
          case .success(_): self._getGiftiCon.onNext(())
          case .failure(_): self._error.onNext(())
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
            
            return response.map { info -> HomePhotoCellModel in
              return HomePhotoCellModel(
                identity: UUID(),
                photoLocalIentifier: info.identifier
              )
            }
            
          case .failure(_):
            self._error.onNext(())
            return nil
        }
      }
      .compactMap { $0 }
      .bind(to: self._photoDataSource)
      .disposed(by: disposeBag)
  }
}

//MARK: - Making
extension DefaultHomeViewModel {
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
