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
        .package(url: "https://github.com/livekit/client-sdk-swift.git", from: "2.0.5"),
    ],
    targets: [
        .binaryTarget(
            name: "KrispNoiseFilter",
            url: "https://github.com/livekit/swift-krisp-noise-filter/releases/download/0.0.1/KrispNoiseFilter.xcframework.zip",
            checksum: "33dd18887b0f5acb9e42d5b7ec0b8a965973c39e4bfd6fd162d3c42f478e4d31"
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
