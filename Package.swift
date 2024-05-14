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
            url: "https://storage.unxpected.co.jp/public/KrispNoiseFilter.xcframework-aeee8ec509705d0bf98b545f2d74e1752aad6b526a9abcb4c0e6918fdd069d40.zip",
            checksum: "aeee8ec509705d0bf98b545f2d74e1752aad6b526a9abcb4c0e6918fdd069d40"
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
