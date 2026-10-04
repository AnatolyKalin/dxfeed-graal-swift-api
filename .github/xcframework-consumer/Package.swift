// swift-tools-version:5.9
// An application of DxFeedGraalNativeSdk.xcframework as SwiftPM uses it (the workflow puts the XCFramework here).
import PackageDescription

let package = Package(
    name: "SdkSmoke",
    platforms: [.iOS(.v14), .macOS(.v14)],
    products: [
        .library(name: "SdkSmoke", targets: ["SdkSmoke"])
    ],
    targets: [
        .binaryTarget(name: "DxFeedGraalNativeSdk", path: "DxFeedGraalNativeSdk.xcframework"),
        .target(name: "SdkSmoke", dependencies: ["DxFeedGraalNativeSdk"]),
        .testTarget(name: "SdkSmokeTests", dependencies: ["SdkSmoke"]),
    ]
)
