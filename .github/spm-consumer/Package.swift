// swift-tools-version:5.9
// An application of DXFeedFramework.xcframework as the clients of the Swift API get it from Package.swift (the
// workflow puts the XCFramework made by the release commands here).
import PackageDescription

let package = Package(
    name: "SpmSmoke",
    platforms: [.iOS(.v14), .macOS(.v14)],
    products: [
        .library(name: "SpmSmoke", targets: ["SpmSmoke"])
    ],
    targets: [
        .binaryTarget(name: "DXFeedFramework", path: "DXFeedFramework.xcframework"),
        .target(name: "SpmSmoke", dependencies: ["DXFeedFramework"]),
        .testTarget(name: "SpmSmokeTests", dependencies: ["SpmSmoke", "DXFeedFramework"]),
    ]
)
