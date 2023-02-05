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
      GifticonRepository.self, implementation: DefaultGifticonRepository()
    )
    
    //MARK: - Domain
    self.injectionContainer(
      WriteGifticon.self, implementation: DefaultWriteGifticon()
    )
    self.injectionContainer(
      FetchGifticon.self, implementation: DefaultFetchGifticon()
    )
    
    //MARK: - Presentation
    self.injectionContainer(
      HomeViewModel.self, implementation: DefaultHomeViewModel()
    )
    self.injectionContainer(
      PickerViewModel.self, implementation: DefaultPickerViewModel()
    )
//    self.injectionHomeContainer(injection)
//    self.injectionPickerContainer(injection)
//    self.injectionWriteGifticon(injection)
//    self.injectionFetchGifticon(injection)
  }
}

////MARK: - Presentation
//extension Injection {
//  func injectionHomeContainer(_ injection: Injection) {
//    injection.dependencyInjected() { container in
//      container.register(HomeViewModel.self) { _ in
//        return DefaultHomeViewModel()
//      }
//      return container
//    }
//  }
//
//  func injectionPickerContainer(_ injection: Injection) {
//    injection.dependencyInjected() { container in
//      container.register(PickerViewModel.self) { _ in
//        return DefaultPickerViewModel()
//      }
//      return container
//    }
//  }
//}
//
////MARK: - UseCase
//extension Injection {
//  func injectionWriteGifticon(_ injection: Injection) {
//    injection.dependencyInjected() { container in
//      container.register(WriteGifticon.self) { _ in
//        return DefaultWriteGifticon()
//      }
//      return container
//    }
//  }
//
//  func injectionFetchGifticon(_ injection: Injection) {
//    injection.dependencyInjected() { container in
//      container.register(FetchGifticon.self) { _ in
//        return DefaultFetchGifticon()
//      }
//      return container
//    }
//  }
//}
//
////MARK: - Repository
//extension Injection {
//  func injectionGiftiRepository(_ injection: Injection) {
//    injection.dependencyInjected() { container in
//      container.register(GifticonRepository.self) { _ in
//        return DefaultGifticonRepository()
//      }
//      return container
//    }
//  }
//}
