// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "PackageName",
    dependencies: [
        .package(
          url: "https://github.com/ReactiveX/RxSwift.git",
          .upToNextMajor(from: "6.5.0")
        ),
        .package(
          url: "https://github.com/Swinject/Swinject.git",
          .upToNextMajor(from: "2.8.0")
        ),
        .package(
          url: "https://github.com/pointfreeco/swift-composable-architecture",
          .upToNextMajor(from: "1.6.0")
        )
    ]
)
