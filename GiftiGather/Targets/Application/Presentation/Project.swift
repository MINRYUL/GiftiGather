import ProjectDescription
import ProjectDescriptionHelpers

let appTarget = AppTarget(target: Application.Presentation)

let target = appTarget.makeTarget(
  dependencies: [
    Domain.Domain.dependency,
    .external(name: "RxCocoa"),
    .external(name: "RxSwift"),
    .external(name: "ComposableArchitecture")
  ]
)

let porject = appTarget.project(targets: [target])
