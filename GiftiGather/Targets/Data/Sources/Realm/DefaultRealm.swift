//
//  DefaultRealm.swift
//  GiftiGather
//
//  Created by 김민창 on 2022/10/15.
//  Copyright © 2022 GiftiGather. All rights reserved.
//

import Foundation

import RxRealm
import RxSwift

final class DefaultRealm {
  static let shared = DefaultRealm()
  
  private init() { }
  
  private let _realm = try! Realm()
  private let _disposeBag: DisposeBag = DisposeBag()
  
  func writeRealm<DTO: DataTransferObject>(
    _ dtoType: DTO.self,
    writeObject: DTO
  ) {
    Observable.from(writeObject)
      .subscribe(self._realm.rx.add())
      .disposed(by: self._disposeBag)
  }
  
  func deleteRealm<DTO: DataTransferObject>(
    _ dtoType: DTO.self
  ) {
    let objects = self._realm.objects(dtoType)
    Observable.from(objects)
      .subscribe(self._realm.rx.delete())
      .disposed(by: self._disposeBag)
  }
  
  
}
