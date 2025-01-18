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
        // Complete package with all models
        .library(
            name: "LiveKitKrispNoiseFilter",
            targets: ["LiveKitKrispNoiseFilter"]
        ),
        // Individual model variants
        .library(
            name: "LiveKitKrispNoiseFilterNC",
            targets: ["LiveKitKrispNoiseFilterNC"]
        ),
        .library(
            name: "LiveKitKrispNoiseFilterBVC",
            targets: ["LiveKitKrispNoiseFilterBVC"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/livekit/client-sdk-swift.git", from: "2.0.13"),
    ],
    targets: [
        // Shared implementation
        .target(
            name: "LiveKitKrispNoiseFilterShared",
            dependencies: [
                .product(name: "LiveKit", package: "client-sdk-swift"),
            ]
        ),
        
        // Complete package target with all models
        .binaryTarget(
            name: "KrispNoiseFilter",
            path: "./KrispNoiseFilter.xcframework.zip"
        ),
        .target(
            name: "LiveKitKrispNoiseFilter",
            dependencies: [
                "LiveKitKrispNoiseFilterShared",
                "KrispNoiseFilter",
            ]
        ),
        
        // NC variant
        .binaryTarget(
            name: "KrispNoiseFilterNC",
            path: "./KrispNoiseFilter-NC.xcframework.zip"
        ),
        .target(
            name: "LiveKitKrispNoiseFilterNC",
            dependencies: [
                "LiveKitKrispNoiseFilterShared",
                "KrispNoiseFilterNC",
            ]
        ),
        
        // BVC variant
        .binaryTarget(
            name: "KrispNoiseFilterBVC",
            path: "./KrispNoiseFilter-BVC.xcframework.zip"
        ),
        .target(
            name: "LiveKitKrispNoiseFilterBVC",
            dependencies: [
                "LiveKitKrispNoiseFilterShared",
                "KrispNoiseFilterBVC",
            ]
        ),
    ]
)
