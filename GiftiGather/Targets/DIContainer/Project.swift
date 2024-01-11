import ProjectDescription
import ProjectDescriptionHelpers

let appTarget = AppTarget(target: DIContainer.DIContainer)

let target = appTarget.makeTarget(
    dependencies: [
        .external(name: "Swinject")
    ]
)

let porject = appTarget.project(targets: [target])
