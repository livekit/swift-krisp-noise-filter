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
        // Default library, contains all supported models. Best for testing or if you need multiple models.
        .library(
            name: "LiveKitKrispNoiseFilter",
            targets: ["LiveKitKrispNoiseFilter"]
        ),

        // Optimized variants that include only a specific model. Best for production.
        // Note: These are code-compatible with the default library, but if you try to use an unsupported model it will fail and/or crash.
        .library(
            name: "LiveKitKrispNoiseFilter-NC", // Contains only the NC model
            targets: ["LiveKitKrispNoiseFilter-NC"]
        ),
        .library(
            name: "LiveKitKrispNoiseFilter-BVC", // Contains only the BVC model
            targets: ["LiveKitKrispNoiseFilter-BVC"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/livekit/client-sdk-swift.git", from: "2.0.13"),
    ],
    targets: [
        // The base implementation is shared between all libraries
        .target(
            name: "Shared",
            dependencies: [
                .product(name: "LiveKit", package: "client-sdk-swift"),
            ]
        ),
        
        // Complete library target with all models
        .binaryTarget(
            name: "KrispNoiseFilter",
            path: "./KrispNoiseFilter.xcframework.zip"
        ),
        .target(
            name: "LiveKitKrispNoiseFilter",
            dependencies: [
                "Shared",
                "KrispNoiseFilter",
            ]
        ),
        
        // NC-only library. Uses an xcframework with other models stripped out.
        .binaryTarget(
            name: "KrispNoiseFilter-NC",
            path: "./KrispNoiseFilter-NC.xcframework.zip"
        ),
        .target(
            name: "LiveKitKrispNoiseFilter-NC",
            dependencies: [
                "Shared",
                "KrispNoiseFilter-NC",
            ]
        ),
        
        // BVC-only library. Uses an xcframework with other models stripped out.
        .binaryTarget(
            name: "KrispNoiseFilter-BVC",
            path: "./KrispNoiseFilter-BVC.xcframework.zip"
        ),
        .target(
            name: "LiveKitKrispNoiseFilter-BVC",
            dependencies: [
                "Shared",
                "KrispNoiseFilter-BVC",
            ]
        ),
    ]
)
