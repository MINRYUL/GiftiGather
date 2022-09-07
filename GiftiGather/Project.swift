import ProjectDescription
import ProjectDescriptionHelpers
import MyPlugin

private enum Layer: String {
  case presentaion = "Presentation"
  case domain = "Domain"
  case data = "Data"
  case core = "Core"
}
// MARK: - Project
let project = Project(
  name: "\(Project.projectName)",
  organizationName: "\(Project.projectName)",
  targets: [
    [Project.makeGiftiGatherAppTarget(
      platform: .iOS,
      dependencies: [
        .target(name: Layer.presentaion.rawValue),
        .target(name: Layer.core.rawValue)
      ]
    )],
    Project.makeGiftiGatherFrameworkTargets(
      name: Layer.presentaion.rawValue,
      platform: .iOS,
      dependencies: [
        .target(name: Layer.domain.rawValue),
        .target(name: Layer.core.rawValue)
      ]
    ),
    Project.makeGiftiGatherFrameworkTargets(
      name: Layer.domain.rawValue,
      platform: .iOS,
      dependencies: [
        .target(name: Layer.core.rawValue)
      ]
    ),
    Project.makeGiftiGatherFrameworkTargets(
      name: Layer.data.rawValue,
      platform: .iOS,
      dependencies: [
        .target(name: Layer.domain.rawValue)
      ]
    ),
    Project.makeGiftiGatherFrameworkTargets(
      name: Layer.core.rawValue,
      platform: .iOS,
      dependencies: [
      ]
    )
  ].flatMap { $0 }
)
