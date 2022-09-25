//
//  HomeViewModel.swift
//  GiftiGather
//
//  Created by 김민창 on 2022/09/17.
//  Copyright © 2022 GiftiGather. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

public struct HomeViewModelInput {
}

public struct HomeViewModelOutput {
  public let filterDataSource: Driver<[HomeFilterCellModel]>
  public let photoDataSource: Driver<[HomePhotoCellModel]>
  public let noDataSource: Driver<[NoDataCellModel]>
}

public protocol HomeViewModel: ViewModel {
  var input: HomeViewModelInput { get set }
  var output: HomeViewModelOutput { get set }
}
