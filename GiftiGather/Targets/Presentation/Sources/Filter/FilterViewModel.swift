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
}

public struct FilterViewModelOutput {
  public let filterDataSource: Driver<[FilterCellModel]>
  public let noDataSource: Driver<[NoDataCellModel]>
}

public protocol FilterViewModel: ViewModel {
  var input: FilterViewModelInput { get set }
  var output: FilterViewModelOutput { get set }
}
