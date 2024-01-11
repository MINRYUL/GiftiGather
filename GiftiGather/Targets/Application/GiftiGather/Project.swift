import ProjectDescription
import ProjectDescriptionHelpers
import MyPlugin

let localHelper = LocalHelper(name: "MyPlugin")

// MARK: Dependencies
let projectDependencies: [TargetDependency] = [
    Application.Presentation.dependency
]

let package: [TargetDependency] = [
]

// MARK: Scheme
let schemeArguments = Arguments(
    environmentVariables: ["OS_ACTIVITY_MODE": "disable"],
    launchArguments: []
)

let schemes: [Scheme] = [
    Scheme(
        name: "Dev",
        shared: true,
        hidden: false,
        buildAction: BuildAction(
            targets: [TargetReference(stringLiteral: "Dev")]
        ),
        testAction: nil,
        runAction: RunAction.runAction(
            configuration: ProjectDescription.ConfigurationName(stringLiteral: "debug"),
            executable: TargetReference(stringLiteral: "Dev"),
            arguments: schemeArguments
        ),
        archiveAction: nil,
        profileAction: nil,
        analyzeAction: nil
    )
]

// MARK: Target
let ioTargetName = "Dev"

let infoPlist: [String: Plist.Value] = [
    "CFBundleShortVersionString": "1.0",
    "CFBundleVersion": "1",
    "UIMainStoryboardFile": "",
    "UILaunchStoryboardName": "LaunchScreen"
]

let dev = Target(
    name: ioTargetName,
    destinations: .iOS,
    product: .app,
    bundleId: "giftiGather.iOS.\(ioTargetName)",
    deploymentTargets: .iOS(AppTarget.deploymentVersion),
    infoPlist: .extendingDefault(with: infoPlist),
    sources: ["Sources/**"],
    resources: ["Resources/**"],
    dependencies: projectDependencies + package
)

// MARK: Project
let giftiGather = Project(
    name: "GiftiGather",
    organizationName: "Minryul",
    options: Project.Options.options(
        automaticSchemesOptions: .disabled,
        developmentRegion: "en",
        disableBundleAccessors: true,
        disableShowEnvironmentVarsInScriptPhases: true,
        disableSynthesizedResourceAccessors: true,
        xcodeProjectName: "GiftiGather"
    ),
    settings:
        Settings.settings(
            configurations:
                [
                    .debug(name: "debug"),
                    .release(name: "release")
                ]
        ),
    targets: [
        dev
    ],
    schemes: schemes,
    fileHeaderTemplate: nil,
    resourceSynthesizers: []
)
