//
//  DetailGiftiViewModel.swift
//  GiftiGather
//
//  Created by 김민창 on 2023/03/05.
//  Copyright © 2023 GiftiGather. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

public struct DetailGiftiViewModelInput {
}

public struct DetailGiftiViewModelOutput {
}

public protocol DetailGiftiViewModel: ViewModel {
  var input: DetailGiftiViewModelInput { get set }
  var output: DetailGiftiViewModelOutput { get set }
}
