//
//  DefaultPickerViewModel.swift
//  PresentationTests
//
//  Created by 김민창 on 2022/09/26.
//  Copyright © 2022 GiftiGather. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

public struct DefaultPickerViewModel: PickerViewModel {
  public var disposeBag: DisposeBag = DisposeBag()
  
  public var input: PickerViewModelInput
  public var output: PickerViewModelOutput
  
  //MARK: - Input
  private let _imageIdentifierList = PublishSubject<[String]>()
  
  //MARK: - Output
  private let _dataSource = BehaviorSubject<[PickCellModel]>(value: [])
  
  
  public init() {
    self.input = PickerViewModelInput(
      imageIdentifierList: self._imageIdentifierList.asObserver()
    )
    
    self.output = PickerViewModelOutput(
      dataSource: self._dataSource.asDriver(onErrorJustReturn: [])
    )
    
    self._bindImageIdentifierList()
  }
}

//MARK: - Input Binding
extension DefaultPickerViewModel {
  private func _bindImageIdentifierList() {
    self._imageIdentifierList
      .map { imageIdentifierList -> [PickCellModel] in
        imageIdentifierList.map { identifier -> PickCellModel in
          return PickCellModel(
            isCheck: true,
            imageIdentifier: identifier
          )
        }
      }
      .bind(to: _dataSource)
      .disposed(by: disposeBag)
  }
}
