// swift-tools-version:5.7
// (Xcode14.0+)

import PackageDescription

let package = Package(
    name: "LiveKitKrispNoiseFilter",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "LiveKitKrispNoiseFilter",
            targets: ["LiveKitKrispNoiseFilter"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/livekit/client-sdk-swift.git", .upToNextMajor(from: "2.0.5")),
    ],
    targets: [
        // .binaryTarget(name: "KrispNoiseFilter", path: "KrispNoiseFilter.xcframework"),
        .binaryTarget(
            name: "KrispNoiseFilter",
            url: "https://storage.unxpected.co.jp/public/KrispNoiseFilter.xcframework.zip",
            checksum: "e56d5ce6def817be4cedc06a444f1f1c0a538ca1d2885c2965fc1a8c305db28f"
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
