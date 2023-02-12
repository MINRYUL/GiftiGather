//
//  FilterCoreObject.swift
//  GiftiGather
//
//  Created by 김민창 on 2023/02/08.
//  Copyright © 2023 GiftiGather. All rights reserved.
//

import Foundation
import CoreData

public final class FilterCoreObject: NSManagedObject {
  @NSManaged public private(set) var filter: String
  
  public init?(
    context: NSManagedObjectContext,
    filter: String
  ) {
    guard let entity = NSEntityDescription.entity(
      forEntityName: CoreModelType.filter.rawValue, in: context
    ) else {
      return nil
    }
    super.init(entity: entity, insertInto: context)
    self.filter = filter
  }
  
  @objc override private init(
    entity: NSEntityDescription, insertInto context: NSManagedObjectContext?
  ) {
    super.init(entity: entity, insertInto: context)
  }
}
