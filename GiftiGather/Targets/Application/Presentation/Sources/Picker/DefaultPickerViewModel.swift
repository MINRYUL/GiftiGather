//
//  DefaultPickerViewModel.swift
//  PresentationTests
//
//  Created by 김민창 on 2022/09/26.
//  Copyright © 2022 GiftiGather. All rights reserved.
//

import Foundation

import DIContainer
import Domain

import RxSwift
import RxCocoa

public struct DefaultPickerViewModel: PickerViewModel {
  public var disposeBag: DisposeBag = DisposeBag()
  
  public var input: PickerViewModelInput
  public var output: PickerViewModelOutput
  
  //MARK: - Input
  private let _imageIdentifierList = PublishSubject<([String], Bool)>()
  private let _didSelectIndex = PublishSubject<IndexPath>()
  private let _didTouchAdd = PublishSubject<Void>()
  
  //MARK: - Output
  private let _dataSource = BehaviorSubject<[PickCellModel]>(value: [])
  private let _selectedImageIdentifiers = PublishSubject<[String]>()
  
  @Injected private var _fetchGifticon: FetchGifticon
  
  public init() {
    self.input = PickerViewModelInput(
      imageIdentifierList: self._imageIdentifierList.asObserver(),
      didSelectIndex: self._didSelectIndex.asObserver(),
      didTouchAdd: self._didTouchAdd.asObserver()
    )
    
    self.output = PickerViewModelOutput(
      dataSource: self._dataSource.asDriver(onErrorJustReturn: []),
      selectedImageIdentifiers: self._selectedImageIdentifiers.asDriver(onErrorJustReturn: [])
    )
    
    self._bindImageIdentifierList()
    self._bindDidSelectIndex()
    self._bindDidTouchAdd()
  }
}

//MARK: - Input Binding
extension DefaultPickerViewModel {
  private func _bindImageIdentifierList() {
    self._imageIdentifierList
      .map { imageIdentifierList, isCheck -> [PickCellModel] in
        let result = self._fetchGifticon.fetchGifticon()
        
        let pickCellModelList = imageIdentifierList.map { identifier -> PickCellModel in
          return PickCellModel(
            isCheck: isCheck,
            imageIdentifier: identifier
          )
        }
        
        switch result {
          case .success(let response):
            if response.isEmpty {
              return pickCellModelList
            }
            
            var identifierMap = [String: Void]()
            
            response.forEach { info in
              identifierMap[info.identifier] = ()
            }
            
            return pickCellModelList.map { model -> PickCellModel? in
              guard let _ = identifierMap[model.imageIdentifier] else {
                return model
              }
              return nil
            }.compactMap { $0 }
            
          case .failure(_):
            return pickCellModelList
        }
      }
      .bind(to: _dataSource)
      .disposed(by: disposeBag)
  }
  
  private func _bindDidSelectIndex() {
    self._didSelectIndex
      .map { indexPath -> [PickCellModel]? in
        guard let dataSource = try? self._dataSource.value() else { return nil }
        
        return dataSource.enumerated().map { index, item in
          switch index == indexPath.item {
            case true:
              return PickCellModel(
                identity: UUID(),
                isCheck: !item.isCheck,
                imageIdentifier: item.imageIdentifier
              )
              
            case false: return item
          }
        }
      }
      .compactMap { $0 }
      .bind(to: _dataSource)
      .disposed(by: disposeBag)
  }
  
  private func _bindDidTouchAdd() {
    self._didTouchAdd
      .map { _ -> [String]? in
        guard let dataSource = try? self._dataSource.value() else { return nil }
        
        return dataSource.map { item -> String? in
          switch item.isCheck {
            case true: return item.imageIdentifier
            case false: return nil
          }
        }.compactMap { $0 }
      }
      .compactMap { $0 }
      .bind(to: self._selectedImageIdentifiers)
      .disposed(by: disposeBag)
  }
}
