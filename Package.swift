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
            checksum: "593c42d889eae9418b4150078d83b0cf6f4b722103d69d3695dee7cfd920e40b"
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
