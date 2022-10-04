//
//  PickerViewModel.swift
//  PresentationTests
//
//  Created by 김민창 on 2022/09/26.
//  Copyright © 2022 GiftiGather. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

public struct PickerViewModelInput {
  public let imageIdentifierList: AnyObserver<([String], Bool)>
  public let didSelectIndex: AnyObserver<IndexPath>
  public let didTouchAdd: AnyObserver<Void>
}

public struct PickerViewModelOutput {
  public let dataSource: Driver<[PickCellModel]>
  public let selectedImageIdentifiers: Driver<[String]>
}

public protocol PickerViewModel: ViewModel {
  var input: PickerViewModelInput { get set }
  var output: PickerViewModelOutput { get set }
}
