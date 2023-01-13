//
//  CoreDataStorage.swift
//  Core
//
//  Created by 김민창 on 2023/01/12.
//  Copyright © 2023 GiftiGather. All rights reserved.
//

import Foundation
import CoreData

import Core

final class CoreDataStorage {
  
  private lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "GiftiModel")
    container.loadPersistentStores { _, error in
      if let error = error as NSError? {
        assertionFailure("CoreDataStorage Unresolved error \(error), \(error.userInfo)")
      }
    }
    return container
  }()
  
  func saveContext() {
    let context = self.persistentContainer.viewContext
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        assertionFailure("CoreDataStorage Unresolved error \(error), \((error as NSError).userInfo)")
      }
    }
  }
  
  func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
    self.persistentContainer.performBackgroundTask(block)
  }
}
