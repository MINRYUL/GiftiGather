//
//  DefaultDetailGiftiViewModel.swift
//  Presentation
//
//  Created by 김민창 on 2023/03/05.
//  Copyright © 2023 GiftiGather. All rights reserved.
//

import Foundation

import DIContainer
import Domain

import RxSwift
import RxCocoa

public struct DefaultDetailGiftiViewModel: DetailGiftiViewModel {
  public var disposeBag: DisposeBag = DisposeBag()
  
  public var input: DetailGiftiViewModelInput
  public var output: DetailGiftiViewModelOutput
  
  public init() {
    self.input = DetailGiftiViewModelInput(
    )
    
    self.output = DetailGiftiViewModelOutput(
    )
  }
  
}

