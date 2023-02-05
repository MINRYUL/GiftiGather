//
//  Injected.swift
//  DIContainer
//
//  Created by 김민창 on 2023/02/05.
//  Copyright © 2023 GiftiGather. All rights reserved.
//

import Foundation

@propertyWrapper public struct Injected<Dependency> {
  public let wrappedValue: Dependency
  
  public init() {
    guard let wrappedValue = Injection.shared.container.resolve(Dependency.self) else {
      fatalError("This instance does not exist.")
    }
    self.wrappedValue = wrappedValue
  }
}
