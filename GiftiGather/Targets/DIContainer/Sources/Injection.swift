//
//  Injection.swift
//  GiftiGather
//
//  Created by 김민창 on 2022/09/17.
//  Copyright © 2022 GiftiGather. All rights reserved.
//

import Foundation

import Swinject

public final class Injection {
  static public let shared = Injection()
  
  public var container: Container {
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
  
  public func dependencyInjected(_ closer: (Container) -> (Container)) {
    self._container = closer(container)
  }
}

@propertyWrapper public struct Injected<Dependency> {
  public let wrappedValue: Dependency
  
  public init() {
    self.wrappedValue =
    Injection.shared.container.resolve(Dependency.self)!
  }
}
