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
    
    let injection = Injection.shared
    self.injectionHomeContainer(injection)
    self.injectionPickerContainer(injection)
    self.injectionWriteGifticon(injection)
  }
}

//MARK: - Presentation
extension Injection {
  func injectionHomeContainer(_ injection: Injection) {
    injection.dependencyInjected() { container in
      container.register(HomeViewModel.self) { _ in
        return DefaultHomeViewModel()
      }
      return container
    }
  }
  
  func injectionPickerContainer(_ injection: Injection) {
    injection.dependencyInjected() { container in
      container.register(PickerViewModel.self) { _ in
        return DefaultPickerViewModel()
      }
      return container
    }
  }
}

//MARK: - UseCase
extension Injection {
  func injectionWriteGifticon(_ injection: Injection) {
    injection.dependencyInjected() { container in
      container.register(WriteGifticon.self) { _ in
        return DefaultWriteGifticon()
      }
      return container
    }
  }
}

//MARK: - Repository
extension Injection {
  func injectionGiftiRepository(_ injection: Injection) {
    injection.dependencyInjected() { container in
      container.register(GifticonRepository.self) { _ in
        return DefaultGifticonRepository()
      }
      return container
    }
  }
}
