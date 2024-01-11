//
//  AppTarget.swift
//  ProjectDescriptionHelpers
//
//  Created by 김민창 on 2023/03/18.
//

import ProjectDescription

public struct AppTarget {
  public static var deploymentVersion: String = "17.0"
  
  private let _target: TargetInterface
  
  private let _schemeArguments = Arguments(
    environmentVariables: ["OS_ACTIVITY_MODE": "disable"],
    launchArguments: []
  )
  
  public init(target: TargetInterface) {
    _target = target
  }
  
  public func makeTarget(
    dependencies: [TargetDependency],
    coreDataModels: [CoreDataModel] = [],
    hasSources: Bool = true,
    hasResources: Bool = false
  ) -> Target {
    
    var resources: [ResourceFileElement] = []
    
    if hasResources {
      resources.append("Resources/**")
    }
    
    var bundleId: String = "giftiGather."
    
    if _target.name.isEmpty {
      bundleId.append(contentsOf: _target.name)
    } else {
      bundleId.append(contentsOf: "\(_target.groupName).\(_target.name)")
    }
      
    return Target(
      name: _target.name,
      destinations: .iOS,
      product: .framework,
      bundleId: bundleId,
      deploymentTargets: .iOS(AppTarget.deploymentVersion),
      sources: hasSources ? ["Sources/**"] : nil,
      resources: ResourceFileElements(resources: resources),
      dependencies: dependencies,
      coreDataModels: coreDataModels
    )
  }
  
  public func makeTestTarget(dependencies: [TargetDependency]) -> Target {
    
    var dependencies = dependencies
    
    dependencies.append(.target(name: _target.name))
    
    return Target(
      name: "\(_target.name)Tests",
      destinations: .iOS,
      product: .unitTests,
      bundleId: "giftiGather.\(_target.groupName).\(_target.name)Tests",
      deploymentTargets: .iOS(AppTarget.deploymentVersion),
      infoPlist: .default,
      sources: ["Tests/**"],
      dependencies: dependencies
    )
  }
    
  private var _scheme: Scheme {
    Scheme(
      name: _target.name,
      shared: true,
      hidden: false,
      buildAction: .init(
        targets: [TargetReference(stringLiteral: _target.name)]
      ),
      testAction: nil,
      runAction: .runAction(
        configuration: .init(stringLiteral: "debug"),
        executable: .init(stringLiteral: _target.name),
        arguments: _schemeArguments
      ),
      archiveAction: nil,
      profileAction: nil,
      analyzeAction: nil
    )
  }
  
  public func project(targets: [Target]) -> Project {
    Project(
      name: _target.name,
      organizationName: "MinChangKim",
      settings: Settings.settings(
        configurations:
          [
            .debug(name: "debug"),
            .release(name: "release")
          ]
      ),
      targets: targets,
      schemes: [_scheme]
    )
  }
}
