import ProjectDescription

/// Project helpers are functions that simplify the way you define your project.
/// Share code to create targets, settings, dependencies,
/// Create your own conventions, e.g: a func that makes sure all shared targets are "static frameworks"
/// See https://docs.tuist.io/guides/helpers/

extension Project {
  public static let projectName: String = "GiftiGather"
  public static let bundleId: String = "com.minryul"
  
  private static let deploymentTarget: DeploymentTarget = .iOS(targetVersion: "13.0", devices: [.iphone])
  
    /// Helper function to create the Project for this ExampleApp
    public static func app(name: String, platform: Platform, additionalTargets: [String]) -> Project {
        var targets = makeAppTargets(name: name,
                                     platform: platform,
                                     dependencies: additionalTargets.map { TargetDependency.target(name: $0) })
        targets += additionalTargets.flatMap({ makeFrameworkTargets(name: $0, platform: platform) })
        return Project(name: name,
                       organizationName: "tuist.io",
                       targets: targets)
    }

    // MARK: - Private

    /// Helper function to create a framework target and an associated unit test target
    private static func makeFrameworkTargets(name: String, platform: Platform) -> [Target] {
        let sources = Target(name: name,
                platform: platform,
                product: .framework,
                bundleId: "io.tuist.\(name)",
                infoPlist: .default,
                sources: ["Targets/\(name)/Sources/**"],
                resources: [],
                dependencies: [])
        let tests = Target(name: "\(name)Tests",
                platform: platform,
                product: .unitTests,
                bundleId: "io.tuist.\(name)Tests",
                infoPlist: .default,
                sources: ["Targets/\(name)/Tests/**"],
                resources: [],
                dependencies: [.target(name: name)])
        return [sources, tests]
    }

    /// Helper function to create the application target and the unit test target.
    private static func makeAppTargets(name: String, platform: Platform, dependencies: [TargetDependency]) -> [Target] {
        let platform: Platform = platform
        let infoPlist: [String: InfoPlist.Value] = [
            "CFBundleShortVersionString": "1.0",
            "CFBundleVersion": "1",
            "UIMainStoryboardFile": "",
            "UILaunchStoryboardName": "LaunchScreen"
            ]

        let mainTarget = Target(
            name: name,
            platform: platform,
            product: .app,
            bundleId: "io.tuist.\(name)",
            infoPlist: .extendingDefault(with: infoPlist),
            sources: ["Targets/\(name)/Sources/**"],
            resources: ["Targets/\(name)/Resources/**"],
            dependencies: dependencies
        )

        let testTarget = Target(
            name: "\(name)Tests",
            platform: platform,
            product: .unitTests,
            bundleId: "io.tuist.\(name)Tests",
            infoPlist: .default,
            sources: ["Targets/\(name)/Tests/**"],
            dependencies: [
                .target(name: "\(name)")
        ])
        return [mainTarget, testTarget]
    }
  
  public static func makeGiftiGatherFrameworkTargets(
    name: String,
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
    platform: Platform,
    dependencies: [TargetDependency]) -> Target {
      
      let platform = platform
      let infoPlist: [String: InfoPlist.Value] = [
          "CFBundleShortVersionString": "1.0",
          "CFBundleVersion": "1",
          "UIMainStoryboardFile": "",
          "UILaunchStoryboardName": "LaunchScreen"
      ]
      
      return .init(name: "\(projectName)",
                   platform: platform,
                   product: .app,
                   bundleId: "\(bundleId)",
                   deploymentTarget: deploymentTarget,
                   infoPlist: .extendingDefault(with: infoPlist),
                   sources: ["Targets/\(projectName)/Sources/**"],
                   resources: ["Targets/\(projectName)/Resources/**"],
//                   entitlements: "./\(projectName).entitlements",
                   dependencies: dependencies
      )
    }
}
