import ProjectDescription
import ProjectDescriptionHelpers

let appTarget = AppTarget(target: Data.Repository)

let target = appTarget.makeTarget(
  dependencies: [
    Domain.Domain.dependency
  ]
)

let porject = appTarget.project(targets: [target])
