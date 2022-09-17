//
//  DefaultHomeViewmodel.swift
//  GiftiGather
//
//  Created by 김민창 on 2022/09/17.
//  Copyright © 2022 GiftiGather. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

public struct DefaultHomeViewModel: HomeViewModel {
  public var disposeBag: DisposeBag = DisposeBag()
  
  public var input: HomeViewModelInput
  public var output: HomeViewModelOutput
  
  public init() {
    self.input = HomeViewModelInput(
    )
    
    self.output = HomeViewModelOutput(
    )
  }
}
