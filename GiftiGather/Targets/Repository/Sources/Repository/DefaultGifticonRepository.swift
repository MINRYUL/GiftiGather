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
  
  public func insertGiftiList(giftiList: [GiftiInfoDTO]) -> Bool {
    let giftiList = giftiList.map { gifti -> GiftiCoreObject? in
      return GiftiCoreObject(
        context: PersistenceManager.shared.backgroundContext,
        identifier: gifti.identifier,
        giftiType: gifti.giftiType,
        giftiValidity: gifti.giftiValidity
      )
    }.compactMap { $0 }
    return PersistenceManager.shared.saveContext()
  }
  
  public func deleteGifti(identity: String) -> Bool {
    let request = NSFetchRequest<GiftiCoreObject>(entityName: CoreModelType.gifti.rawValue)
    request.predicate = NSPredicate(format: "id = %@", identity)
    let fetchResult = PersistenceManager.shared.fetch(request: request)
    guard let fetch = fetchResult.last else { return false }
    return PersistenceManager.shared.delete(object: fetch)
  }
  
  public func fetchGiftiList() -> [GiftiInfoDTO] {
    let request = NSFetchRequest<GiftiCoreObject>(entityName: CoreModelType.gifti.rawValue)
    let fetchResult = PersistenceManager.shared.fetch(request: request)
    return fetchResult.map { result -> GiftiInfoDTO in
      return GiftiInfoDTO(
        identifier: result.identifier,
        giftiType: result.giftiType,
        giftiValidity: result.giftiValidity
      )
    }
  }
}
