//
//  PhotoAuthManage.swift
//  GiftiGather
//
//  Created by 김민창 on 2022/09/17.
//  Copyright © 2022 GiftiGather. All rights reserved.
//

import Foundation
import Photos

enum PhotoAuth {
  case authorized, denied, notDetermined, restricted
}

struct PhotoAuthManager {
  @discardableResult
  static func requestPhotosPermissionCheck() -> PhotoAuth {
    let photoAuthorizationStatusStatus = PHPhotoLibrary.authorizationStatus()
    switch photoAuthorizationStatusStatus {
      case .authorized: return .authorized
      case .denied: return .denied
      case .notDetermined:
        PHPhotoLibrary.requestAuthorization() { _ in }
        return .notDetermined
      case .restricted: return .restricted
      default: return .restricted
    }
  }
}
