//
//  HomeViewModel.swift
//  GiftiGather
//
//  Created by 김민창 on 2022/09/17.
//  Copyright © 2022 GiftiGather. All rights reserved.
//

import Foundation

import Domain

import RxSwift
import RxCocoa

public struct HomeViewModelInput {
  public let selectedImageIdentifers: AnyObserver<[String]>
  public let getGiftiCon: AnyObserver<Void>
  public let selectedFilterList: AnyObserver<[String]>
  public let selectedGifti: AnyObserver<IndexPath>
}

public struct HomeViewModelOutput {
  public let filterDataSource: Driver<[HomeFilterCellModel]>
  public let photoDataSource: Driver<[HomePhotoCellModel]>
  public let noDataSource: Driver<[NoDataCellModel]>
  public let confirmSelect: Driver<(IndexPath, String)?>
  public let didDeleteNoData: Driver<[UUID]>
  public let error: Driver<Void>
}

public protocol HomeViewModel: ViewModel {
  var input: HomeViewModelInput { get set }
  var output: HomeViewModelOutput { get set }
}
