//
//  DefaultRealm.swift
//  GiftiGather
//
//  Created by 김민창 on 2022/10/15.
//  Copyright © 2022 GiftiGather. All rights reserved.
//

import Foundation

import Core

import RealmSwift

final class DefaultRealm {
  static let shared = DefaultRealm()
  
  private let _realm = try! Realm()
  
  private init() { }
  
  public func write<T: Object>(_ objectType: T.Type) -> Result<T, Error> {
    
    do {
      try self._realm.write {
        _realm.add(T)
        return .success(T)
      }
    } catch {
      return .failure(DefaultError.write)
    }
  }
}
