//
//  HomeViewModel.swift
//  GiftiGather
//
//  Created by 김민창 on 2022/09/17.
//  Copyright © 2022 GiftiGather. All rights reserved.
//

import Foundation

public struct HomeViewModelInput {
  
}

public struct HomeViewModelOutput {
  
}

public protocol HomeViewModel: ViewModel {
  var input: HomeViewModelInput { get set }
  var output: HomeViewModelOutput { get set }
}
