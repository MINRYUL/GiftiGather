//
//  Injection+Extesnion.swift
//  DIContainer
//
//  Created by 김민창 on 2022/09/17.
//  Copyright © 2022 GiftiGather. All rights reserved.
//

import Foundation
import DIContainer

import Swinject

extension Injection {
  func injectionContainer() {
    
    let injection = Injection.shared
    self.injectionHomeContainer(injection)
  }
  
  func injectionHomeContainer(_ injection: Injection) {
    injection.dependencyInjected() { container in
      
      return container
    }
  }
}
