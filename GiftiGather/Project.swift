import ProjectDescription
import ProjectDescriptionHelpers
import MyPlugin

private let projectName: String = "GiftiGather"
private let bundleId: String = "com.minryul"

// MARK: - Project
let project = Project.giftiGatherApp(
  name: projectName,
  bundleId: bundleId,
  platform: .iOS
)
