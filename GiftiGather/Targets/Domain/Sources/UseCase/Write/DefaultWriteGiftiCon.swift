//
//  WriteGiftiCon.swift
//  GiftiGather
//
//  Created by 김민창 on 2022/10/15.
//  Copyright © 2022 GiftiGather. All rights reserved.
//

import Foundation

import Core

import RxSwift

public struct DefaultWriteGifticon {
  
  private var _disposeBag: DisposeBag = DisposeBag()
  
  
  func writeGifticon(requestValue: WriteGifticonRequestValue) -> Observable<Result<Void, DefaultError>> {
    
    return Observable.create() { emitter in
      
      emitter.onNext(.success(()))
      
      return Disposables.create()
    }
  }
}
