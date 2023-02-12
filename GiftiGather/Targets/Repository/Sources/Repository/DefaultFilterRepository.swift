//
//  DefaultFilterRepository.swift
//  Domain
//
//  Created by 김민창 on 2023/02/11.
//  Copyright © 2023 GiftiGather. All rights reserved.
//

import Foundation
import CoreData

import Core
import Domain

public struct DefaultFilterRepository: FilterRepository {
  
  public init() { }
  
  public func insertFilter(filter: String) -> Result<Void, DefaultError> {
    _ = FilterCoreObject(
      context: PersistenceManager.shared.backgroundContext,
      filter: filter
    )
    
    return PersistenceManager.shared.saveContext()
  }
  
  public func deleteFilter(identity: String) -> Result<Void, DefaultError> {
    let request = NSFetchRequest<FilterCoreObject>(entityName: CoreModelType.filter.rawValue)
    request.predicate = NSPredicate(format: "id = %@", identity)
    let fetchResult = PersistenceManager.shared.fetch(request: request)
    guard let fetch = fetchResult.last else { return .failure(DefaultError.nonExistentIndex) }
    return PersistenceManager.shared.delete(object: fetch)
  }
  
  public func fetchFilter() -> Result<[String], DefaultError> {
    let request = NSFetchRequest<FilterCoreObject>(entityName: CoreModelType.filter.rawValue)
    let fetchResult: [AnyObject] = PersistenceManager.shared.fetch(request: request)
    var filterList = [String]()
    for fetchModel in fetchResult {
      filterList.append(fetchModel.filter)
    }
    return .success(filterList)
  }
}
