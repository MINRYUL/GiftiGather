//
//  DefaultGifticonRepository.swift
//  GiftiGather
//
//  Created by 김민창 on 2022/10/15.
//  Copyright © 2022 GiftiGather. All rights reserved.
//

import Foundation
import CoreData

import Core
import Domain

public struct DefaultGifticonRepository: GifticonRepository {
  
  public init() { }
  
  public func insertGiftiList(giftiList: [GiftiInfoDTO]) -> Result<Void, DefaultError> {
    giftiList.forEach { gifti in
      _ = GiftiCoreObject(
        context: PersistenceManager.shared.backgroundContext,
        identifier: gifti.identifier,
        giftiType: gifti.giftiType,
        giftiValidity: gifti.giftiValidity,
        filter: gifti.filter
      )
    }
    return PersistenceManager.shared.saveContext()
  }
  
  public func deleteGifti(identity: String) -> Result<Void, DefaultError> {
    let request = NSFetchRequest<GiftiCoreObject>(entityName: CoreModelType.gifti.rawValue)
    request.predicate = NSPredicate(format: "identity = %@", identity)
    let fetchResult = PersistenceManager.shared.fetch(request: request)
    guard let fetch = fetchResult.last else { return .failure(DefaultError.nonExistentIndex) }
    return PersistenceManager.shared.delete(object: fetch)
  }
  
  public func fetchGiftiList() -> Result<[GiftiInfoDTO], DefaultError> {
    let request = NSFetchRequest<GiftiCoreObject>(entityName: CoreModelType.gifti.rawValue)
    let fetchResult: [AnyObject] = PersistenceManager.shared.fetch(request: request)
    var giftiInfoList = [GiftiInfoDTO]()
    for fetchModel in fetchResult {
      giftiInfoList.append(
        GiftiInfoDTO(
          identifier: fetchModel.identifier,
          giftiType: fetchModel.giftiType,
          giftiValidity: fetchModel.giftiValidity,
          filter: fetchModel.filter
        )
      )
    }
    return .success(giftiInfoList)
  }
}
