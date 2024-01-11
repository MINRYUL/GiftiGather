//
//  FilterViewModel.swift
//  GiftiGather
//
//  Created by 김민창 on 2023/02/08.
//  Copyright © 2023 GiftiGather. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

public struct FilterViewModelInput {
  public let getFilter: AnyObserver<Void>
  public let storeFilter: AnyObserver<String?>
  public let didSelectIndex: AnyObserver<IndexPath>
  public let didTouchConfirm: AnyObserver<Void>
  public let didTouchDelete: AnyObserver<Void>
}

public struct FilterViewModelOutput {
  public let filterDataSource: Driver<[FilterCellModel]>
  public let noDataSource: Driver<[NoDataCellModel]>
  public let updateItems: Driver<[FilterCellModel]?>
  public let isDeleteMode: Driver<Bool>
  public let didDeleteFilters: Driver<[UUID]>
  public let didDeleteNoData: Driver<[UUID]>
  public let error: Driver<String>
  public let confirm: Driver<[String]>
}

public protocol FilterViewModel: ViewModel {
  var input: FilterViewModelInput { get set }
  var output: FilterViewModelOutput { get set }
}
