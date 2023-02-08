//
//  GiftiCoreModel.swift
//  Data
//
//  Created by 김민창 on 2023/01/13.
//  Copyright © 2023 GiftiGather. All rights reserved.
//

import Foundation
import CoreData

public final class GiftiCoreObject: NSManagedObject {
  @NSManaged public private(set) var identifier: String
  @NSManaged public var giftiType: String
  @NSManaged public var giftiValidity: String
  @NSManaged public var filter: String?
  
  public init?(
    context: NSManagedObjectContext,
    identifier: String,
    giftiType: String,
    giftiValidity: String,
    filter: String?
  ) {
    guard let entity = NSEntityDescription.entity(
      forEntityName: CoreModelType.gifti.rawValue, in: context
    ) else {
      return nil
    }
    super.init(entity: entity, insertInto: context)
    self.identifier = identifier
    self.giftiType = giftiType
    self.giftiValidity = giftiValidity
    self.filter = filter
  }
  
  @objc override private init(
    entity: NSEntityDescription, insertInto context: NSManagedObjectContext?
  ) {
    super.init(entity: entity, insertInto: context)
  }
}
