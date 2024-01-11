import ProjectDescription
import ProjectDescriptionHelpers

let appTarget = AppTarget(target: Core.Core)

let target = appTarget.makeTarget(
  dependencies: [
    DIContainer.DIContainer.dependency
  ]
)

let porject = appTarget.project(targets: [target])
