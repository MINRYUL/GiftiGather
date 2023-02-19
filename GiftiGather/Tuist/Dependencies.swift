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
      url: "https://github.com/ReactiveX/RxSwift.git",
      requirement: .upToNextMajor(from: "6.5.0")
    ),
    .remote(
      url: "https://github.com/Swinject/Swinject.git",
      requirement: .upToNextMajor(from: "2.8.0")
    ),
    .remote(
      url: "https://github.com/pointfreeco/swift-composable-architecture",
      requirement: .upToNextMajor(from: "0.51.0")
    )
  ],
  platforms: [.iOS]
)
