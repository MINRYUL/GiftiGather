import ProjectDescription

/// Project helpers are functions that simplify the way you define your project.
/// Share code to create targets, settings, dependencies,
/// Create your own conventions, e.g: a func that makes sure all shared targets are "static frameworks"
/// See https://docs.tuist.io/guides/helpers/

extension Project {
  private enum Layer: String {
    case presentaion = "Presentation"
    case domain = "Domain"
    case data = "Data"
    case core = "Core"
    case diContainer = "DIContainer"
  }
  
  private static let deploymentTarget: DeploymentTarget = .iOS(targetVersion: "13.0", devices: [.iphone])
  
  public static func giftiGatherApp(
    name: String,
    bundleId: String,
    platform: Platform
  ) -> Project {
    return Project(
      name: name,
      organizationName: name,
      targets: [
        [Project.makeGiftiGatherAppTarget(
          name: name,
          platform: platform,
          bundleId: bundleId,
          dependencies: [
            .target(name: Layer.diContainer.rawValue),
            .target(name: Layer.presentaion.rawValue),
            .target(name: Layer.domain.rawValue),
            .external(name: "Swinject"),
            .external(name: "RxSwift"),
            .external(name: "RxCocoa")
          ]
        )],
        Project.makeGiftiGatherFrameworkTargets(
          name: Layer.presentaion.rawValue,
          bundleId: bundleId,
          platform: .iOS,
          dependencies: [
            .target(name: Layer.diContainer.rawValue),
            .target(name: Layer.domain.rawValue),
            .target(name: Layer.core.rawValue),
            .external(name: "RxSwift"),
            .external(name: "RxCocoa")
          ]
        ),
        Project.makeGiftiGatherFrameworkTargets(
          name: Layer.domain.rawValue,
          bundleId: bundleId,
          platform: .iOS,
          dependencies: [
            .target(name: Layer.diContainer.rawValue),
            .target(name: Layer.core.rawValue)
          ]
        ),
        Project.makeGiftiGatherFrameworkTargets(
          name: Layer.data.rawValue,
          bundleId: bundleId,
          platform: .iOS,
          dependencies: [
            .target(name: Layer.domain.rawValue),
            .target(name: Layer.core.rawValue),
            .external(name: "RealmSwift"),
            .external(name: "RxSwift"),
            .external(name: "RxRealm")
          ]
        ),
        Project.makeGiftiGatherFrameworkTargets(
          name: Layer.core.rawValue,
          bundleId: bundleId,
          platform: .iOS,
          dependencies: [
          ]
        ),
        Project.makeGiftiGatherFrameworkTargets(
          name: Layer.diContainer.rawValue,
          bundleId: bundleId,
          platform: .iOS,
          dependencies: [
            .external(name: "Swinject")
          ]
        )
      ].flatMap { $0 }
    )
  }
  
  
  public static func makeGiftiGatherFrameworkTargets(
    name: String,
    bundleId: String,
    platform: Platform,
    dependencies: [TargetDependency]) -> [Target] {
      let sources = Target(
        name: name,
        platform: platform,
        product: .framework,
        bundleId: "\(bundleId).\(name)",
        deploymentTarget: deploymentTarget,
        infoPlist: .default,
        sources: ["Targets/\(name)/Sources/**"],
        resources: [],
//        entitlements: "./\(projectName).entitlements",
        dependencies: dependencies
      )
      
      let tests = Target(
        name: "\(name)Tests",
        platform: platform,
        product: .unitTests,
        bundleId: "\(bundleId).\(name)Tests",
        deploymentTarget: deploymentTarget,
        infoPlist: .default,
        sources: ["Targets/\(name)/Tests/**"],
        resources: [],
        dependencies: [
          .target(name: name)
        ]
      )
      
      return [sources, tests]
    }
  
  public static func makeGiftiGatherAppTarget(
    name: String,
    platform: Platform,
    bundleId: String,
    dependencies: [TargetDependency]
  ) -> Target {
      
      let platform = platform
      let infoPlist: [String: InfoPlist.Value] = [
          "CFBundleShortVersionString": "1.0",
          "CFBundleVersion": "1",
          "UIMainStoryboardFile": "",
          "UILaunchStoryboardName": "LaunchScreen",
          "NSPhotoLibraryUsageDescription": "Request permission to access the photo album",
          "UISupportedInterfaceOrientations": ["UIInterfaceOrientationPortrait"]
      ]
      
      return .init(name: name,
                   platform: platform,
                   product: .app,
                   bundleId: bundleId,
                   deploymentTarget: deploymentTarget,
                   infoPlist: .extendingDefault(with: infoPlist),
                   sources: ["Targets/\(name)/Sources/**"],
                   resources: ["Targets/\(name)/Resources/**"],
//                   entitlements: "./\(projectName).entitlements",
                   dependencies: dependencies
      )
    }
}
