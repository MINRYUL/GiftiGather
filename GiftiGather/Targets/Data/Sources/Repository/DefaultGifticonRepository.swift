//
//  DefaultGifticonRepository.swift
//  GiftiGather
//
//  Created by 김민창 on 2022/10/15.
//  Copyright © 2022 GiftiGather. All rights reserved.
//

import Foundation

import Core
import Domain

import RxCocoa
import RxSwift

public struct DefaultGifticonRepository: GiftiConRepository {
  private var _disposeBag: DisposeBag = DisposeBag()
  
  public func writeGifticon(gifticonList: [GiftiInfoDTO]) -> Observable<Result<Void, DefaultError>> {
    
    return Observable.create() { emitter in
      gifticonList.forEach { gifticon in
        
      }
      
      emitter.onNext(.success(()))
      emitter.onCompleted()
      return Disposables.create()
    }
  }
  
  public func deleteGifticon() -> Observable<Result<Void, DefaultError>> {
    return Observable.create() { emitter in
      
      
      emitter.onNext(.success(()))
      emitter.onCompleted()
      return Disposables.create()
    }
  }
}
