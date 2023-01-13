//
//  PersistenceManager.swift
//  Data
//
//  Created by 김민창 on 2023/01/13.
//  Copyright © 2023 GiftiGather. All rights reserved.
//

import Foundation
import CoreData

final class PersistenceManager {
  static var shared: PersistenceManager = PersistenceManager()
  
  private init() { }
  
  private lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "GiftiModel")
    container.loadPersistentStores { _, error in
      if let error = error as NSError? {
        assertionFailure("CoreDataStorage Unresolved error \(error), \(error.userInfo)")
      }
    }
    return container
  }()
  
  lazy var backgroundContext: NSManagedObjectContext = {
    return persistentContainer.newBackgroundContext()
  }()
  
  func saveContext() -> Bool {
    let context = self.backgroundContext
    if context.hasChanges {
      do {
        try context.save()
        return true
      } catch {
        assertionFailure("CoreDataStorage Unresolved error \(error), \((error as NSError).userInfo)")
      }
    }
    return false
  }
  
  @discardableResult
  func insert(object: NSManagedObject?) -> Bool {
    return self.saveContext()
  }
  
  func fetch<T: NSManagedObject>(request: NSFetchRequest<T>) -> [T] {
    do {
      let fetchResult = try self.backgroundContext.fetch(request)
      return fetchResult
    } catch {
      print(error.localizedDescription)
      return []
    }
  }
  
  @discardableResult
  func delete(object: NSManagedObject) -> Bool {
    self.backgroundContext.delete(object)
    return self.saveContext()
  }
  
  @discardableResult
  func deleteAll<T: NSManagedObject>(request: NSFetchRequest<T>) -> Bool {
    let request: NSFetchRequest<NSFetchRequestResult> = T.fetchRequest()
    let delete = NSBatchDeleteRequest(fetchRequest: request)
    do {
      try self.backgroundContext.execute(delete)
      return true
    } catch {
      return false
    }
  }
}
