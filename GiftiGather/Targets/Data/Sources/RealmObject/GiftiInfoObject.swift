//
//  GiftiInfoObject.swift
//  GiftiGather
//
//  Created by 김민창 on 2022/11/19.
//  Copyright © 2022 GiftiGather. All rights reserved.
//

import Foundation

import RealmSwift
import Realm

class GiftiInfoObject: Realm.Object {
  @Persisted(primaryKey: true) var identifier: String
  @Persisted var giftiType: String
  @Persisted var giftiValidity: String
}
