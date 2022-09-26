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

import Swinject

extension Injection {
  func injectionContainer() {
    
    let injection = Injection.shared
    self.injectionHomeContainer(injection)
    self.injectionPickerContainer(injection)
  }
  
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
