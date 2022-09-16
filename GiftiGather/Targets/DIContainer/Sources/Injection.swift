//
//  Injection.swift
//  GiftiGather
//
//  Created by 김민창 on 2022/09/17.
//  Copyright © 2022 GiftiGather. All rights reserved.
//

import Foundation

import Swinject

final class Injection {
  static let shared = Injection()
  
  var container: Container {
    get {
      guard let container = _container else {
        let container = buildContainer()
        return container
      }
      return container
    }
    set {
      _container = newValue
    }
  }
  private var _container: Container?
  
  private func buildContainer() -> Container {
    let container = Container()
    
    return container
  }
}

@propertyWrapper struct Injected<Dependency> {
  let wrappedValue: Dependency
  
  init() {
    self.wrappedValue =
    Injection.shared.container.resolve(Dependency.self)!
  }
}
