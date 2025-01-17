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
            url: "https://github.com/livekit/swift-krisp-noise-filter/raw/913d47a13477cdd85e583d7f7b306b867942120d/KrispNoiseFilter.xcframework.zip"
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
