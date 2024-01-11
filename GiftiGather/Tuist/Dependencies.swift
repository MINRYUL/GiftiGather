import ProjectDescription
import ProjectDescriptionHelpers

let dependencies = Dependencies(
    carthage: [],
    swiftPackageManager: SwiftPackageManagerDependencies(
        productTypes: [
            "ComposableArchitecture": .framework,
        ],
        baseSettings: Settings.settings(
            configurations:
                [
                    .debug(name: "debug"),
                    .release(name: "release")
                ]
        )
    ),
    platforms: [.iOS]
)
