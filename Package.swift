// swift-tools-version:5.7
// (Xcode14.0+)

import PackageDescription

let package = Package(
    name: "LiveKitKrispNoiseFilter",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
    ],
    products: [
        .library(
            name: "LiveKitKrispNoiseFilter",
            targets: ["LiveKitKrispNoiseFilter"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/livekit/client-sdk-swift.git", from: "2.0.13"),
    ],
    targets: [
        .binaryTarget(
            name: "KrispNoiseFilter",
            url: "https://github.com/livekit/swift-krisp-noise-filter/releases/download/0.0.7/KrispNoiseFilter.xcframework.zip",
            checksum: "2d8446bdd0a0fabc47f9739c4eefd980959ba16683a9b01b1feb7e34c420dae7"
        ),
        .target(
            name: "LiveKitKrispNoiseFilter",
            dependencies: [
                .product(name: "LiveKit", package: "client-sdk-swift"),
                "KrispNoiseFilter",
            ]
        ),
    ]
)
