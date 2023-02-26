//
//  Injection+Extesnion.swift
//  DIContainer
//
//  Created by 김민창 on 2022/09/17.
//  Copyright © 2022 GiftiGather. All rights reserved.
//

import Foundation
import DIContainer
import Presentation
import Domain
import Repository

import Swinject

extension Injection {
  func injectionContainer() {
    //MARK: - Repository
    self.injectionContainer(
      GifticonRepository.self, implementation: { DefaultGifticonRepository() }
    )
    self.injectionContainer(
      FilterRepository.self, implementation: { DefaultFilterRepository() }
    )
    
    //MARK: - Domain
    self.injectionContainer(
      WriteGifticon.self, implementation: { DefaultWriteGifticon() }
    )
    self.injectionContainer(
      FetchGifticon.self, implementation: { DefaultFetchGifticon() }
    )
    self.injectionContainer(
      FetchFilter.self, implementation: { DefaultFetchFilter() }
    )
    self.injectionContainer(
      WriteFilter.self, implementation: { DefaultWriteFilter() }
    )
    self.injectionContainer(
      DeleteFilter.self, implementation: { DefaultDeleteFilter() }
    )
    
    //MARK: - Presentation
    
    self.injectionContainer(
      HomeViewModel.self, implementation: { DefaultHomeViewModel() }
    )
    self.injectionContainer(
      PickerViewModel.self, implementation: { DefaultPickerViewModel() }
    )
    self.injectionContainer(
      FilterViewModel.self, implementation: { DefaultFilterViewModel() }
    )
    
  }
}
