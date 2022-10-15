//
//  Dependencies.swift
//  Config
//
//  Created by 김민창 on 2022/09/16.
//

import ProjectDescription
import ProjectDescriptionHelpers

let dependencies = Dependencies(
  carthage: [],
  swiftPackageManager: [
    .remote(
      url: "https://github.com/realm/realm-swift.git",
      requirement: .upToNextMajor(from: "10.32.0")
    ),
    .remote(
      url: "https://github.com/ReactiveX/RxSwift.git",
      requirement: .upToNextMajor(from: "6.5.0")
    ),
    .remote(
      url: "https://github.com/Swinject/Swinject.git",
      requirement: .upToNextMajor(from: "2.8.0")
    ),
    .remote(
      url: "https://github.com/RxSwiftCommunity/RxRealm.git",
      requirement: .upToNextMajor(from: "5.0.5")
    )
  ],
  platforms: [.iOS]
)
