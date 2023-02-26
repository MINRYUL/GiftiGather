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
  
  private init() { }
  
  public var container: Container {
    get {
      guard let container = _container else {
        let container = Container()
        _container = container
        return container
      }
      return container
    }
    set {
      _container = newValue
    }
  }
  private var _container: Container?
  
  private func _dependencyInjected(_ closer: (Container) -> (Container)) {
    self._container = closer(container)
  }
}

//MARK: - Public
extension Injection {
  public func injectionContainer<Interface>(
    _ interfaceType: Interface.Type,
    implementation: @escaping () -> Interface
  ) {
    self._dependencyInjected() { container in
      container.register(Interface.self) { _ in
        return implementation()
      }.inObjectScope(.graph)
      return container
    }
  }
  
  public func injectionContainer<Interface>(
    _ interfaceType: Interface.Type,
    implementation: Interface
  ) {
    self._dependencyInjected() { container in
      container.register(Interface.self) { _ in
        return implementation
      }.inObjectScope(.graph)
      return container
    }
  }
}
